"""Turn Wan flap clips (wan_flap.py) into the game's wing-beat sprites.

    COMFYUI_API_URL=http://127.0.0.1:8188 python3 tool/skins/wan_frames.py <ids|accepted>
    python3 tool/skins/wan_frames.py --apply <ids|staged>
    python3 tool/skins/wan_frames.py --reencode

1. Stage: for each skin, the clip wan_score.py accepts; its first wing-beat
   cycle is cut out on the L40S (RMBG-2.0), aligned on the body axis,
   cropped with one shared box, cut down to MAX_FRAMES evenly spaced frames
   and saved as WebP in out/staged/<id>/ with source.json (clip, score,
   warnings). Nothing in assets/ changes. `accepted` = every skin that has
   an accepted clip and does not flap in the app yet.
2. --apply: copies staged frames to assets/skins/duck/<id>_N.webp, removes
   that skin's old frames and rewrites the Dart catalog. Run it only for
   skins the user approved on the review page (build_review.py).
3. --reencode: turns the PNG frames already in the app into WebP, same
   frames and count.
"""

import json
import shutil
import sys
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from animate import body_axis, wait  # noqa: E402
from export_to_app import ASSETS, SPRITE_PX, all_styles, cutout_graph, frame_count, upload, write_all_catalog  # noqa: E402
from generate import DEFAULT_ENV, Comfy, load_env  # noqa: E402
from wan_score import accepted_clip, frames as clip_frames, load_score  # noqa: E402

STAGED = HERE / "out" / "staged"
# A beat lasts 0.30-0.43 s in the game; more frames than this are not seen.
MAX_FRAMES = 8
# Hard pixel edges: lossy WebP smears them, lossless keeps them and stays small.
LOSSLESS = {"pixel8", "pixel16", "handheld", "cga", "vga_dos", "isopixel", "ascii"}


def save_webp(im, dest, sid):
    if sid in LOSSLESS:
        im.save(dest, "WEBP", lossless=True, method=6)
    else:
        im.save(dest, "WEBP", quality=85, method=6)


def pick(n_frames):
    """Indices of at most MAX_FRAMES frames spread evenly over one beat."""
    if n_frames <= MAX_FRAMES:
        return list(range(n_frames))
    return [round(i * n_frames / MAX_FRAMES) for i in range(MAX_FRAMES)]


def cut(comfy, jobs):
    """jobs: {(sid, clip dir): n_frames}; cut-outs cached as c_NN.png in the clip."""
    pending = {}
    for (sid, clip), n_frames in jobs.items():
        for n in range(n_frames):
            if (clip / f"c_{n:02d}.png").exists():
                continue
            name = upload(comfy, clip / f"f_{n:02d}.png", name=f"wancut_{sid}_{clip.name}_{n:02d}.png")
            pending[comfy.submit(cutout_graph(name, f"kaceny_wancut_{sid}_{n}"))] = clip / f"c_{n:02d}.png"
    print(f"cutting {len(pending)} frames", flush=True)
    wait(comfy, pending, lambda dest, png: dest.write_bytes(png))


def stage(sid, clip, n_frames):
    frames = [Image.open(clip / f"c_{n:02d}.png").convert("RGBA") for n in range(n_frames)]
    warnings = []
    if any(f.getchannel("A").getbbox() is None for f in frames):
        raise ValueError(f"{sid}: a frame is empty after the cut-out")
    for n, f in enumerate(frames):
        a = f.getchannel("A")
        w, h = a.size
        edge = max(a.crop(box).getextrema()[1] for box in ((0, 0, w, 2), (0, h - 2, w, h), (0, 0, 2, h), (w - 2, 0, w, h)))
        if edge > 24:
            warnings.append(f"frame {n} touches the clip edge (wing cut off?)")
            break
    # Shift only: Wan's camera holds still, so the duck keeps its size, and the
    # body length measured under a wing that covers it is not worth trusting.
    rx, ry, _ = body_axis(frames[0])
    aligned = []
    for f in frames:
        x, y, _ = body_axis(f)
        canvas = Image.new("RGBA", f.size, (0, 0, 0, 0))
        canvas.paste(f, (round(rx - x), round(ry - y)), f)
        aligned.append(canvas)
    boxes = [a.getchannel("A").point(lambda v: 255 if v > 24 else 0).getbbox() for a in aligned]
    half = max(max(rx - b[0], b[2] - rx, ry - b[1], b[3] - ry) for b in boxes)
    box = (round(rx - half), round(ry - half), round(rx + half), round(ry + half))
    dest = STAGED / sid
    shutil.rmtree(dest, ignore_errors=True)
    dest.mkdir(parents=True)
    keep = pick(n_frames)
    for i, n in enumerate(keep):
        save_webp(aligned[n].crop(box).resize((SPRITE_PX, SPRITE_PX), Image.LANCZOS), dest / f"{i}.webp", sid)
    (dest / "source.json").write_text(json.dumps({
        "clip": clip.name, "cycle": n_frames, "frames": len(keep), "score": load_score(clip), "warnings": warnings}))
    print(f"  {sid}: {clip.name}, beat of {n_frames} -> {len(keep)} frames{'  ! ' + '; '.join(warnings) if warnings else ''}")


def apply(ids):
    for sid in ids:
        src = sorted((STAGED / sid).glob("*.webp"), key=lambda p: int(p.stem))
        if not src:
            print(f"  {sid}: nothing staged")
            continue
        for old in list(ASSETS.joinpath("duck").glob(f"{sid}_*.webp")) + list(ASSETS.joinpath("duck").glob(f"{sid}_*.png")):
            if old.stem[len(sid) + 1:].isdigit():  # only this skin's frames
                old.unlink()
        for f in src:
            shutil.copyfile(f, ASSETS / "duck" / f"{sid}_{f.stem}.webp")
        print(f"  {sid}: {len(src)} frames")
    write_all_catalog()


def reencode():
    for _, _, _, sid, _ in all_styles():
        pngs = sorted((p for p in ASSETS.joinpath("duck").glob(f"{sid}_*.png") if p.stem[len(sid) + 1:].isdigit()),
                      key=lambda p: int(p.stem[len(sid) + 1:]))
        for p in pngs:
            save_webp(Image.open(p).convert("RGBA"), p.with_suffix(".webp"), sid)
            p.unlink()
        if pngs:
            print(f"  {sid}: {len(pngs)} frames -> webp")
    write_all_catalog()


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    if sys.argv[1] == "--reencode":
        return reencode()
    if sys.argv[1] == "--apply":
        ids = sys.argv[2] if len(sys.argv) > 2 else sys.exit("--apply <ids|staged>")
        return apply(sorted(d.name for d in STAGED.iterdir() if d.is_dir()) if ids == "staged" else ids.split(","))
    if sys.argv[1] == "accepted":
        ids = [s[3] for s in all_styles() if frame_count(s[3]) == 1]
    else:
        ids = sys.argv[1].split(",")
    jobs = {}
    for sid in ids:
        clip = accepted_clip(sid)
        if clip is None:
            if sys.argv[1] != "accepted":
                print(f"  {sid}: no accepted clip")
            continue
        jobs[(sid, clip)] = load_score(clip)["cycle"]
    if not jobs:
        return print("nothing to stage")
    if any(not (clip / f"c_{n - 1:02d}.png").exists() for (_, clip), n in jobs.items()):
        load_env(str(DEFAULT_ENV))
        cut(Comfy(local_only=True), jobs)
    for (sid, clip), n_frames in jobs.items():
        stage(sid, clip, n_frames)
    print(f"staged {len(jobs)} skins in {STAGED}")


if __name__ == "__main__":
    main()
