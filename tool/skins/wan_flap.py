"""Wing-beat clips from a duck sprite with Wan 2.2 image-to-video on ComfyUI.

    COMFYUI_API_URL=https://comfyui.ol1n.com python3 tool/skins/wan_flap.py classic,robot,...

The generated duck becomes the first frame of a short clip of it flapping in
place (14B I2V, high/low-noise experts with the 4-step Seko LoRAs). Every
frame is saved to tool/skins/out/wan/<id>/f_NN.png for wan_frames.py to pick
one wing-beat cycle from.
"""

import random
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from export_to_app import upload  # noqa: E402
from generate import DEFAULT_ENV, Comfy, load_env  # noqa: E402

OUT = HERE / "out"
WAN = OUT / "wan"
SIZE = 512
LENGTH = 33  # 2 s at 16 fps: several beats

PROMPT = ("The duck flaps its wings up and down in a strong steady rhythm, full wing beats, "
          "seen from directly above. The body stays still in the centre of the frame, "
          "static camera, the plain light grey background does not change.")
NEGATIVE = ("camera movement, zoom, panning, rotation, the bird moving across the frame, flying away, "
            "background change, blurry, distorted, extra wings, extra limbs, text, watermark")


def wan_graph(image_name, seed, prefix):
    def expert(unet_id, lora_id, shift_id, unet, lora):
        return {
            unet_id: {"class_type": "UNETLoader", "inputs": {"unet_name": unet, "weight_dtype": "default"}},
            lora_id: {"class_type": "LoraLoaderModelOnly", "inputs": {"model": [unet_id, 0], "lora_name": lora, "strength_model": 1.0}},
            shift_id: {"class_type": "ModelSamplingSD3", "inputs": {"model": [lora_id, 0], "shift": 5.0}},
        }

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
        "12": {"class_type": "WanImageToVideo", "inputs": {
            "positive": ["8", 0], "negative": ["9", 0], "vae": ["10", 0], "start_image": ["11", 0],
            "width": SIZE, "height": SIZE, "length": LENGTH, "batch_size": 1}},
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
    import json
    hist = json.loads(comfy._req(f"/history/{pid}"))
    if pid not in hist:
        return None
    entry = hist[pid]
    if entry.get("status", {}).get("status_str") == "error":
        raise RuntimeError(f"comfy error: {json.dumps(entry.get('status'))[:600]}")
    return [img for node in entry.get("outputs", {}).values() for img in node.get("images", [])]


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    ids = sys.argv[1].split(",")
    load_env(str(DEFAULT_ENV))
    comfy = Comfy()
    pending = {}
    for sid in ids:
        if (WAN / sid / "f_00.png").exists():
            continue
        name = upload(comfy, OUT / "duck" / f"{sid}.jpg")
        pending[comfy.submit(wan_graph(name, random.randrange(2**32), f"kaceny_wan_{sid}"))] = sid
    print(f"rendering {len(pending)} clips", flush=True)
    t0 = time.time()
    while pending:
        time.sleep(5)
        for pid in list(pending):
            imgs = all_images(comfy, pid)
            if imgs is None:
                continue
            sid = pending.pop(pid)
            (WAN / sid).mkdir(parents=True, exist_ok=True)
            for i, img in enumerate(imgs):
                (WAN / sid / f"f_{i:02d}.png").write_bytes(comfy.download(img))
            print(f"  {sid}: {len(imgs)} frames ({time.time() - t0:.0f}s)", flush=True)


if __name__ == "__main__":
    main()
