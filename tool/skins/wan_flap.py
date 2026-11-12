"""Wing-beat clips from a duck sprite with Wan 2.2 image-to-video on ComfyUI.

    COMFYUI_API_URL=http://127.0.0.1:8188 python3 tool/skins/wan_flap.py <ids|pilot|todo> [--seeds N] [--recipe R]

Runs only against the L40S tunnel on this Mac (never SPARK). The generated
duck becomes the first frame of a short clip of it flapping in place (14B I2V,
high/low-noise experts). Each clip lands in out/wan/<id>/<recipe>-<seed>/
(f_NN.png + meta.json) for wan_score.py to judge and wan_frames.py to cut.

- ids: comma-separated style ids, `pilot` (PILOT) or `todo` (every style
  whose sprite in assets/ does not flap yet)
- --seeds N: make sure each skin has N clips of this recipe; skins with an
  accepted clip (wan_score.py) are skipped, and no skin gets more than
  MAX_CLIPS clips in all
- --recipe: `seko` (I2V with the 4-step Seko LoRAs) or `flf` (the same
  models, first and last frame both the duck, which forces the loop shut)

Prompts in flight are kept in out/wan/pending.json, so an interrupted run
picks them up again instead of queueing them twice.
"""

import argparse
import json
import random
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from export_to_app import ASSETS, all_styles, frame_count, upload  # noqa: E402
from generate import DEFAULT_ENV, Comfy, load_env  # noqa: E402
from wan_score import accepted_clip, clip_dirs, migrate_legacy  # noqa: E402

OUT = HERE / "out"
WAN = OUT / "wan"
PENDING = WAN / "pending.json"
SIZE = 512
LENGTH = 33  # 2 s at 16 fps: several beats
MAX_CLIPS = 5
RECIPES = ("seko", "flf")

# Three that failed before, and one of each kind of look that could trip Wan up.
PILOT = ["synthwave", "deco", "naturalist", "cga", "watercolor", "clay", "vector_crt", "neonsign", "diamond", "photo"]

PROMPT = ("The duck flaps its wings up and down in a strong steady rhythm, full wing beats, "
          "seen from directly above. The body stays still in the centre of the frame, "
          "static camera, the plain light grey background does not change.")
NEGATIVE = ("camera movement, zoom, panning, rotation, the bird moving across the frame, flying away, "
            "background change, blurry, distorted, extra wings, extra limbs, text, watermark")


def wan_graph(image_name, seed, prefix, recipe="seko"):
    def expert(unet_id, lora_id, shift_id, unet, lora):
        return {
            unet_id: {"class_type": "UNETLoader", "inputs": {"unet_name": unet, "weight_dtype": "default"}},
            lora_id: {"class_type": "LoraLoaderModelOnly", "inputs": {"model": [unet_id, 0], "lora_name": lora, "strength_model": 1.0}},
            shift_id: {"class_type": "ModelSamplingSD3", "inputs": {"model": [lora_id, 0], "shift": 5.0}},
        }

    video = {"positive": ["8", 0], "negative": ["9", 0], "vae": ["10", 0], "start_image": ["11", 0],
             "width": SIZE, "height": SIZE, "length": LENGTH, "batch_size": 1}
    if recipe == "flf":
        # The clip has to come back to the duck it started from.
        video_node = {"class_type": "WanFirstLastFrameToVideo", "inputs": {**video, "end_image": ["11", 0]}}
    else:
        video_node = {"class_type": "WanImageToVideo", "inputs": video}
    g = {
        **expert("1", "2", "3", "wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors",
                 "Wan2.2-I2V-A14B-4steps-lora-rank64-Seko-V1_high_noise_model.safetensors"),
        **expert("4", "5", "6", "wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors",
                 "Wan2.2-I2V-A14B-4steps-lora-rank64-Seko-V1_low_noise_model.safetensors"),
        "7": {"class_type": "CLIPLoader", "inputs": {"clip_name": "umt5_xxl_fp8_e4m3fn_scaled.safetensors", "type": "wan", "device": "default"}},
        "8": {"class_type": "CLIPTextEncode", "inputs": {"text": PROMPT, "clip": ["7", 0]}},
        "9": {"class_type": "CLIPTextEncode", "inputs": {"text": NEGATIVE, "clip": ["7", 0]}},
        "10": {"class_type": "VAELoader", "inputs": {"vae_name": "wan_2.1_vae.safetensors"}},
        "11": {"class_type": "LoadImage", "inputs": {"image": image_name}},
        "12": video_node,
        "13": {"class_type": "KSamplerAdvanced", "inputs": {
            "model": ["3", 0], "add_noise": "enable", "noise_seed": seed, "steps": 4, "cfg": 1.0,
            "sampler_name": "euler", "scheduler": "simple", "positive": ["12", 0], "negative": ["12", 1],
            "latent_image": ["12", 2], "start_at_step": 0, "end_at_step": 2, "return_with_leftover_noise": "enable"}},
        "14": {"class_type": "KSamplerAdvanced", "inputs": {
            "model": ["6", 0], "add_noise": "disable", "noise_seed": seed, "steps": 4, "cfg": 1.0,
            "sampler_name": "euler", "scheduler": "simple", "positive": ["12", 0], "negative": ["12", 1],
            "latent_image": ["13", 0], "start_at_step": 2, "end_at_step": 10000, "return_with_leftover_noise": "disable"}},
        "15": {"class_type": "VAEDecode", "inputs": {"samples": ["14", 0], "vae": ["10", 0]}},
        "16": {"class_type": "SaveImage", "inputs": {"filename_prefix": prefix, "images": ["15", 0]}},
    }
    return g


def all_images(comfy, pid):
    """Every image of a finished prompt, in order; None while it runs."""
    hist = json.loads(comfy._req(f"/history/{pid}"))
    if pid not in hist:
        return None
    entry = hist[pid]
    if entry.get("status", {}).get("status_str") == "error":
        raise RuntimeError(f"comfy error: {json.dumps(entry.get('status'))[:600]}")
    return [img for node in entry.get("outputs", {}).values() for img in node.get("images", [])]


def resolve_ids(arg):
    if arg == "pilot":
        return PILOT
    if arg == "todo":
        return [s[3] for s in all_styles() if frame_count(s[3]) == 1 and (ASSETS / "duck" / f"{s[3]}.png").exists()]
    return arg.split(",")


def load_pending():
    return json.loads(PENDING.read_text()) if PENDING.exists() else {}


def save_pending(pending):
    WAN.mkdir(parents=True, exist_ok=True)
    PENDING.write_text(json.dumps(pending, indent=1))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("ids")
    ap.add_argument("--seeds", type=int, default=2)
    ap.add_argument("--recipe", choices=RECIPES, default="seko")
    args = ap.parse_args()
    load_env(str(DEFAULT_ENV))
    comfy = Comfy(local_only=True)

    pending = load_pending()
    for sid in resolve_ids(args.ids):
        migrate_legacy(sid)
        if accepted_clip(sid):
            continue
        clips = clip_dirs(sid)
        have = sum(1 for c in clips if c.name.startswith(args.recipe + "-")) + sum(
            1 for p in pending.values() if p["id"] == sid and p["recipe"] == args.recipe)
        room = MAX_CLIPS - len(clips) - sum(1 for p in pending.values() if p["id"] == sid)
        want = min(args.seeds - have, room)
        if want <= 0:
            continue
        name = upload(comfy, OUT / "duck" / f"{sid}.jpg", name=f"wan_src_{sid}.jpg")
        for _ in range(want):
            seed = random.randrange(2**32)
            pid = comfy.submit(wan_graph(name, seed, f"kaceny_wan_{sid}_{args.recipe}_{seed}", args.recipe))
            pending[pid] = {"id": sid, "recipe": args.recipe, "seed": seed, "submitted": time.time()}
        save_pending(pending)
    print(f"{len(pending)} clips in flight", flush=True)

    t0 = time.time()
    while pending:
        time.sleep(5)
        for pid in list(pending):
            job = pending[pid]
            try:
                imgs = all_images(comfy, pid)
            except RuntimeError as e:
                print(f"  FAIL {job['id']} {job['recipe']}-{job['seed']}: {e}", flush=True)
                del pending[pid]
                save_pending(pending)
                continue
            if imgs is None:
                continue
            dest = WAN / job["id"] / f"{job['recipe']}-{job['seed']}"
            dest.mkdir(parents=True, exist_ok=True)
            for i, img in enumerate(imgs):
                (dest / f"f_{i:02d}.png").write_bytes(comfy.download(img))
            secs = time.time() - job["submitted"]
            (dest / "meta.json").write_text(json.dumps({**job, "frames": len(imgs), "secs_since_submit": round(secs)}))
            del pending[pid]
            save_pending(pending)
            print(f"  {job['id']} {dest.name}: {len(imgs)} frames ({time.time() - t0:.0f}s, {len(pending)} left)",
                  flush=True)


if __name__ == "__main__":
    main()
