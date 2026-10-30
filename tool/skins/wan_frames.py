"""Turn Wan flap clips (wan_flap.py) into the game's wing-beat sprites.

    COMFYUI_API_URL=https://comfyui.ol1n.com python3 tool/skins/wan_frames.py classic,robot,...

Takes the FIRST wing-beat cycle of each clip (later in the clip Wan tends to
turn the bird around): the cycle ends at the frame most like frame 0. Those
frames are cut out on ComfyUI, aligned on the body axis and cropped with one
shared box -> assets/skins/duck/<id>_0..N-1.png, replacing Kontext frames.
"""

import sys
from pathlib import Path

from PIL import Image, ImageChops, ImageStat

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from animate import body_axis, wait  # noqa: E402
from export_to_app import ASSETS, SPRITE_PX, cutout_graph, upload, write_all_catalog  # noqa: E402
from generate import DEFAULT_ENV, Comfy, load_env  # noqa: E402

WAN = HERE / "out" / "wan"
MIN_CYCLE, MAX_CYCLE = 6, 16


def cycle_length(sid):
    """Frames in the first beat: the index (6..16) of the frame most like frame 0."""
    def thumb(n):
        return Image.open(WAN / sid / f"f_{n:02d}.png").convert("L").resize((64, 64))

    first = thumb(0)
    frames = sorted(WAN.joinpath(sid).glob("f_*.png"))
    scores = {n: ImageStat.Stat(ImageChops.difference(first, thumb(n))).mean[0]
              for n in range(MIN_CYCLE, min(MAX_CYCLE, len(frames) - 1) + 1)}
    return min(scores, key=scores.get)


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    ids = sys.argv[1].split(",")
    load_env(str(DEFAULT_ENV))
    comfy = Comfy()

    cycles = {sid: cycle_length(sid) for sid in ids}
    pending = {}
    for sid, n_frames in cycles.items():
        print(f"{sid}: cycle of {n_frames} frames", flush=True)
        for n in range(n_frames):
            if (WAN / sid / f"c_{n:02d}.png").exists():
                continue
            name = upload(comfy, WAN / sid / f"f_{n:02d}.png", name=f"wan_{sid}_{n:02d}.png")
            pending[comfy.submit(cutout_graph(name, f"kaceny_wancut_{sid}_{n}"))] = (sid, n)
    print(f"cutting {len(pending)} frames", flush=True)
    wait(comfy, pending, lambda key, png: (WAN / key[0] / f"c_{key[1]:02d}.png").write_bytes(png))

    for sid, n_frames in cycles.items():
        frames = [Image.open(WAN / sid / f"c_{n:02d}.png").convert("RGBA") for n in range(n_frames)]
        rx, ry, rlen = body_axis(frames[0])
        aligned = []
        for f in frames:
            x, y, length = body_axis(f)
            k = rlen / length
            scaled = f.resize((round(f.width * k), round(f.height * k)), Image.LANCZOS)
            canvas = Image.new("RGBA", f.size, (0, 0, 0, 0))
            canvas.paste(scaled, (round(rx - x * k), round(ry - y * k)), scaled)
            aligned.append(canvas)
        boxes = [a.getchannel("A").point(lambda v: 255 if v > 24 else 0).getbbox() for a in aligned]
        half = max(max(rx - b[0], b[2] - rx, ry - b[1], b[3] - ry) for b in boxes)
        box = (round(rx - half), round(ry - half), round(rx + half), round(ry + half))
        for old in ASSETS.joinpath("duck").glob(f"{sid}_*.png"):
            if old.stem[len(sid) + 1:].isdigit():  # only this skin's frames
                old.unlink()
        for n, a in enumerate(aligned):
            a.crop(box).resize((SPRITE_PX, SPRITE_PX), Image.LANCZOS).save(
                ASSETS / "duck" / f"{sid}_{n}.png", optimize=True)
    write_all_catalog()
    print(f"wan frames for {len(ids)} skins")


if __name__ == "__main__":
    main()
