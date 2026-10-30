"""Wing-beat frames for duck skins, made with Flux Kontext on ComfyUI.

    COMFYUI_API_URL=https://comfyui.ol1n.com python3 tool/skins/animate.py classic,robot,...

The generated duck (wings level) is frame 1. Kontext edits it into frame 0
(upstroke) and frame 2 (downstroke), keeping the bird, style and framing.
All three are cut out and cropped with ONE shared box, so the body stays put
and only the wings move between frames:
    assets/skins/duck/<id>_0.png, <id>_1.png, <id>_2.png
Then the Dart skin catalog is rewritten so the game picks the frames up.
"""

import io
import random
import sys
import time
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from export_to_app import ASSETS, SPRITE_PX, cutout_graph, upload, write_all_catalog  # noqa: E402
from generate import DEFAULT_ENV, Comfy, load_env  # noqa: E402

OUT = HERE / "out"
FRAMES = OUT / "frames"

KEEP = ("Keep exactly the same duck, the same art style, colors and line work, the same body position, "
        "size and orientation (head pointing down), and the same plain light grey background.")
EDITS = {
    0: "Change only the wings: the wings are raised in the upstroke, lifted up and folded closer to the body, "
       "so seen from directly above they look shorter and narrower. " + KEEP,
    2: "Change only the wings: the wings are in the downstroke, swept down and forward with the wing tips "
       "curving toward the head. " + KEEP,
}


def kontext_graph(image_name, prompt, seed, prefix):
    return {
        "1": {"class_type": "UNETLoader", "inputs": {"unet_name": "flux1-dev-kontext_fp8_scaled.safetensors", "weight_dtype": "default"}},
        "2": {"class_type": "DualCLIPLoader", "inputs": {"clip_name1": "clip_l.safetensors", "clip_name2": "t5xxl_fp16.safetensors", "type": "flux", "device": "default"}},
        "3": {"class_type": "VAELoader", "inputs": {"vae_name": "ae.safetensors"}},
        "4": {"class_type": "LoadImage", "inputs": {"image": image_name}},
        "5": {"class_type": "FluxKontextImageScale", "inputs": {"image": ["4", 0]}},
        "6": {"class_type": "VAEEncode", "inputs": {"pixels": ["5", 0], "vae": ["3", 0]}},
        "7": {"class_type": "CLIPTextEncode", "inputs": {"text": prompt, "clip": ["2", 0]}},
        "8": {"class_type": "ReferenceLatent", "inputs": {"conditioning": ["7", 0], "latent": ["6", 0]}},
        "9": {"class_type": "FluxGuidance", "inputs": {"conditioning": ["8", 0], "guidance": 2.5}},
        "10": {"class_type": "CLIPTextEncode", "inputs": {"text": "", "clip": ["2", 0]}},
        "11": {"class_type": "KSampler", "inputs": {
            "seed": seed, "steps": 20, "cfg": 1, "sampler_name": "euler", "scheduler": "simple", "denoise": 1,
            "model": ["1", 0], "positive": ["9", 0], "negative": ["10", 0], "latent_image": ["6", 0]}},
        "12": {"class_type": "VAEDecode", "inputs": {"samples": ["11", 0], "vae": ["3", 0]}},
        "13": {"class_type": "SaveImage", "inputs": {"filename_prefix": prefix, "images": ["12", 0]}},
    }


def wait(comfy, pending, on_done):
    while pending:
        time.sleep(2)
        for pid in list(pending):
            img = comfy.result(pid)
            if img is None:
                continue
            on_done(pending.pop(pid), comfy.download(img))


def make_frames(comfy, ids):
    """frames/<id>_<n>.png at the source duck's size; frame 1 is the source."""
    FRAMES.mkdir(parents=True, exist_ok=True)
    pending = {}
    for sid in ids:
        src = OUT / "duck" / f"{sid}.jpg"
        Image.open(src).convert("RGB").save(FRAMES / f"{sid}_1.png")
        name = None
        for n, prompt in EDITS.items():
            if (FRAMES / f"{sid}_{n}.png").exists():
                continue
            name = name or upload(comfy, src)
            pid = comfy.submit(kontext_graph(name, prompt, random.randrange(2**32), f"kaceny_frame_{sid}_{n}"))
            pending[pid] = (sid, n)
    print(f"generating {len(pending)} frames", flush=True)

    def done(key, png):
        sid, n = key
        size = Image.open(OUT / "duck" / f"{sid}.jpg").size
        Image.open(io.BytesIO(png)).convert("RGB").resize(size, Image.LANCZOS).save(FRAMES / f"{sid}_{n}.png")
        print(f"  frame {sid}_{n}", flush=True)

    wait(comfy, pending, done)


def cut_frames(comfy, ids):
    pending = {}
    for sid in ids:
        for n in range(3):
            if (FRAMES / f"{sid}_{n}_cut.png").exists():
                continue
            name = upload(comfy, FRAMES / f"{sid}_{n}.png")
            pending[comfy.submit(cutout_graph(name, f"kaceny_framecut_{sid}_{n}"))] = (sid, n)
    print(f"cutting {len(pending)} frames", flush=True)
    wait(comfy, pending, lambda key, png: (FRAMES / f"{key[0]}_{key[1]}_cut.png").write_bytes(png))


def body_axis(im):
    """(centre x, centre y, length) of the body along the centre line.

    Measured in a narrow vertical band through the bird's middle, where the
    head, body and tail are but the wings are not, so the wing pose does not
    change it. Kontext zooms its edits a little; this undoes that.
    """
    alpha = im.getchannel("A").point(lambda a: 255 if a > 24 else 0)
    l, t, r, b = alpha.getbbox()
    cx = (l + r) / 2
    half = max(2, round(im.width * 0.04))
    band = alpha.crop((round(cx) - half, 0, round(cx) + half, im.height)).getbbox()
    return cx, (band[1] + band[3]) / 2, band[3] - band[1]


def sprites(sid):
    frames = [Image.open(FRAMES / f"{sid}_{n}_cut.png").convert("RGBA") for n in range(3)]
    if any(f.getchannel("A").getbbox() is None for f in frames):
        raise ValueError(f"{sid}: a frame is empty after the cut-out")
    # Scale and move frames 0 and 2 so their body matches frame 1's.
    rx, ry, rlen = body_axis(frames[1])
    aligned = []
    for f in frames:
        x, y, length = body_axis(f)
        k = rlen / length
        scaled = f.resize((round(f.width * k), round(f.height * k)), Image.LANCZOS)
        canvas = Image.new("RGBA", f.size, (0, 0, 0, 0))
        canvas.paste(scaled, (round(rx - x * k), round(ry - y * k)), scaled)  # clips off-canvas parts
        aligned.append(canvas)
    # One square around all frames, centred on the body, so only the wings move.
    boxes = [a.getchannel("A").point(lambda v: 255 if v > 24 else 0).getbbox() for a in aligned]
    half = max(max(rx - b[0], b[2] - rx, ry - b[1], b[3] - ry) for b in boxes)
    box = (round(rx - half), round(ry - half), round(rx + half), round(ry + half))
    for n, a in enumerate(aligned):
        a.crop(box).resize((SPRITE_PX, SPRITE_PX), Image.LANCZOS).save(ASSETS / "duck" / f"{sid}_{n}.png", optimize=True)


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    ids = sys.argv[1].split(",")
    load_env(str(DEFAULT_ENV))
    comfy = Comfy()
    make_frames(comfy, ids)
    cut_frames(comfy, ids)
    for sid in ids:
        sprites(sid)
    write_all_catalog()
    print(f"animated {len(ids)} skins")


if __name__ == "__main__":
    main()
