"""Generate the skin curation images on ComfyUI (Flux schnell).

    python3 tool/skins/generate.py [--env PATH] [--only duck|bg|target] [--window N]

Reads COMFYUI_API_URL (env wins over the file, e.g.
COMFYUI_API_URL=https://comfyui.ol1n.com) and optional CF_ACCESS_CLIENT_ID/SECRET from the
environment or from --env (defaults to Kiran's pipeline/.env). Images land in
tool/skins/out/<kind>/<id>.jpg; existing files are skipped, so re-running
resumes. The curation page is rebuilt at the end (build_html.py).
"""

import argparse
import json
import os
import random
import subprocess
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from catalog import jobs  # noqa: E402

OUT = HERE / "out"
DEFAULT_ENV = HERE.parents[2] / "Kiran" / "pipeline" / ".env"


def load_env(path):
    if path and Path(path).exists():
        for line in Path(path).read_text().splitlines():
            if "=" in line and not line.lstrip().startswith("#"):
                k, v = line.split("=", 1)
                os.environ.setdefault(k.strip(), v.strip())


def workflow(prompt, w, h, seed, prefix):
    return {
        "1": {"class_type": "UNETLoader", "inputs": {"unet_name": "flux1-schnell.safetensors", "weight_dtype": "default"}},
        "2": {"class_type": "DualCLIPLoader", "inputs": {"clip_name1": "clip_l.safetensors", "clip_name2": "t5xxl_fp16.safetensors", "type": "flux", "device": "default"}},
        "3": {"class_type": "VAELoader", "inputs": {"vae_name": "ae.safetensors"}},
        "4": {"class_type": "CLIPTextEncode", "inputs": {"text": prompt, "clip": ["2", 0]}},
        "5": {"class_type": "CLIPTextEncode", "inputs": {"text": "", "clip": ["2", 0]}},
        "6": {"class_type": "EmptySD3LatentImage", "inputs": {"width": w, "height": h, "batch_size": 1}},
        "8": {"class_type": "KSampler", "inputs": {
            "seed": seed, "steps": 4, "cfg": 1, "sampler_name": "euler", "scheduler": "simple", "denoise": 1,
            "model": ["1", 0], "positive": ["4", 0], "negative": ["5", 0], "latent_image": ["6", 0]}},
        "9": {"class_type": "VAEDecode", "inputs": {"samples": ["8", 0], "vae": ["3", 0]}},
        "10": {"class_type": "SaveImage", "inputs": {"filename_prefix": prefix, "images": ["9", 0]}},
    }


class Comfy:
    def __init__(self):
        self.base = os.environ["COMFYUI_API_URL"].rstrip("/")
        self.headers = {"Content-Type": "application/json", "User-Agent": "kaceny-skins/1.0"}
        if os.environ.get("CF_ACCESS_CLIENT_ID"):
            self.headers["CF-Access-Client-Id"] = os.environ["CF_ACCESS_CLIENT_ID"]
            self.headers["CF-Access-Client-Secret"] = os.environ.get("CF_ACCESS_CLIENT_SECRET", "")

    def _req(self, path, data=None):
        body = json.dumps(data).encode() if data is not None else None
        req = urllib.request.Request(self.base + path, data=body, headers=self.headers)
        with urllib.request.urlopen(req, timeout=60) as r:
            return r.read()

    def submit(self, graph):
        return json.loads(self._req("/prompt", {"prompt": graph}))["prompt_id"]

    def result(self, pid):
        """Image file info once the prompt finished, else None."""
        hist = json.loads(self._req(f"/history/{pid}"))
        if pid not in hist:
            return None
        entry = hist[pid]
        if entry.get("status", {}).get("status_str") == "error":
            raise RuntimeError(f"comfy error for {pid}")
        for node in entry.get("outputs", {}).values():
            for img in node.get("images", []):
                return img
        raise RuntimeError(f"no image in output of {pid}")

    def download(self, img):
        q = urllib.parse.urlencode({"filename": img["filename"], "subfolder": img["subfolder"], "type": img["type"]})
        return self._req(f"/view?{q}")


def save(png, dest, max_px):
    tmp = dest.with_suffix(".png")
    tmp.write_bytes(png)
    subprocess.run(["sips", "-s", "format", "jpeg", "-s", "formatOptions", "82", "-Z", str(max_px),
                    str(tmp), "--out", str(dest)], check=True, capture_output=True)
    tmp.unlink()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--env", default=str(DEFAULT_ENV))
    ap.add_argument("--only", choices=["duck", "bg", "target"])
    ap.add_argument("--window", type=int, default=4, help="prompts in flight at once")
    args = ap.parse_args()
    load_env(args.env)
    comfy = Comfy()

    all_jobs = jobs()
    manifest = []
    todo = []
    for kind, jid, prompt, w, h, meta in all_jobs:
        dest = OUT / kind / f"{jid}.jpg"
        manifest.append({"kind": kind, "id": jid, "file": f"{kind}/{jid}.jpg", "prompt": prompt, **meta})
        if (args.only is None or args.only == kind) and not dest.exists():
            todo.append((kind, jid, prompt, w, h, dest))
    OUT.mkdir(exist_ok=True)
    (OUT / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=1))
    print(f"{len(todo)} to generate ({len(all_jobs) - len(todo)} done/skipped)", flush=True)

    inflight = {}
    done = failed = 0
    t0 = time.time()
    while todo or inflight:
        while todo and len(inflight) < args.window:
            kind, jid, prompt, w, h, dest = todo.pop(0)
            dest.parent.mkdir(parents=True, exist_ok=True)
            pid = comfy.submit(workflow(prompt, w, h, random.randrange(2**32), f"kaceny_{kind}_{jid}"))
            inflight[pid] = (kind, jid, dest)
        time.sleep(2)
        for pid in list(inflight):
            kind, jid, dest = inflight[pid]
            try:
                img = comfy.result(pid)
                if img is None:
                    continue
                save(comfy.download(img), dest, 1024 if kind == "bg" else 512)
                done += 1
                rate = (time.time() - t0) / done
                print(f"[{done}] {kind}/{jid}  ~{rate:.1f}s/img, {len(todo) + len(inflight) - 1} left", flush=True)
            except Exception as e:  # keep going; a re-run retries what is missing
                failed += 1
                print(f"FAIL {kind}/{jid}: {e}", flush=True)
            del inflight[pid]

    print(f"done {done}, failed {failed}", flush=True)
    subprocess.run([sys.executable, str(HERE / "build_html.py")], check=True)


if __name__ == "__main__":
    main()
