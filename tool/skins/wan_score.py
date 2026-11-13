"""Judge Wan flap clips (wan_flap.py) and pick one per skin.

    python3 tool/skins/wan_score.py <ids|pilot|all> [--sheets] [--out DIR]

For each clip in out/wan/<id>/<clip>/ the first wing-beat cycle is measured
on a mask made by thresholding against the plain background (RMBG is only
run on the winner, in wan_frames.py) and written to score.json:

- cycle:  frames in the first beat, ending at the frame most like frame 0
- tilt:   largest angle of the body axis from vertical, in degrees: the bird
          turned to the side or into profile
- drift:  largest move of the body's centre, as a share of its length: it
          flew off or wandered
- motion: largest share of the silhouette that differs from frame 0: under
          MIN_MOTION it barely moved
- loop:   how far the last frame of the beat is from frame 0, against the
          typical step between neighbours: high means the loop jumps

A clip passes when tilt, drift and motion are within limits; loop only ranks
passing clips. Thresholds come from the 15 clips made before this tool:
the 12 shipped ones and synthwave, deco and naturalist (all three turned).

Masks cannot see everything (a compact bird's wings can look like a tilt),
so --sheets draws out/wan/sheets/<id>.png, one row per clip, for a person
or an agent to look at. Their call goes in out/wan/verdicts.json,
{"<id>": {"<clip>": {"ok": true|false, "note": "..."}}}, and beats the
numbers: an `ok` clip is picked first, a `false` one never.
"""

import json
import shutil
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

HERE = Path(__file__).resolve().parent
WAN = HERE / "out" / "wan"
VERDICTS = WAN / "verdicts.json"


def set_root(path):
    """Keep clips somewhere other than out/wan (a GPU job's own folder)."""
    global WAN, VERDICTS
    WAN = Path(path).resolve()
    VERDICTS = WAN / "verdicts.json"
MIN_CYCLE, MAX_CYCLE = 6, 16
MAX_TILT = 12.0
MAX_DRIFT = 0.3
MIN_MOTION = 0.35

# Three that failed before, and one of each kind of look that could trip Wan up.
PILOT = ["synthwave", "deco", "naturalist", "cga", "watercolor", "clay", "vector_crt", "neonsign", "diamond", "photo"]


def migrate_legacy(sid):
    """Clips from before seeds were kept sat straight in out/wan/<id>/."""
    root = WAN / sid
    if not (root / "f_00.png").exists():
        return
    dest = root / "legacy"
    dest.mkdir(exist_ok=True)
    for f in list(root.glob("f_*.png")) + list(root.glob("c_*.png")):
        shutil.move(str(f), dest / f.name)
    (dest / "meta.json").write_text(json.dumps({"id": sid, "recipe": "seko", "seed": None}))


def clip_dirs(sid):
    root = WAN / sid
    return sorted(d for d in root.iterdir() if d.is_dir() and (d / "f_00.png").exists()) if root.exists() else []


def frames(clip):
    return sorted(clip.glob("f_*.png"))


def mask(path):
    a = np.asarray(Image.open(path).convert("RGB")).astype(np.int16)
    border = np.concatenate([a[0], a[-1], a[:, 0], a[:, -1]])
    m = np.abs(a - np.median(border, axis=0)).max(axis=2) > 28
    im = Image.fromarray((m * 255).astype(np.uint8)).filter(ImageFilter.MinFilter(3)).filter(ImageFilter.MaxFilter(3))
    return np.asarray(im) > 0


def thumb(path):
    return np.asarray(Image.open(path).convert("L").resize((64, 64))).astype(float)


def cycle_length(clip):
    """Frames in the first beat: the index (6..16) of the frame most like frame 0."""
    fs = frames(clip)
    first = thumb(fs[0])
    scores = {n: np.abs(first - thumb(fs[n])).mean() for n in range(MIN_CYCLE, min(MAX_CYCLE, len(fs) - 1) + 1)}
    return min(scores, key=scores.get)


def body_tilt(m):
    """Angle of the body from vertical: main axis of the silhouette in a
    narrow band through the middle, where the wings are thin and the body long."""
    ys, xs = np.nonzero(m)
    cx = int(np.median(xs))
    half = int(m.shape[1] * 0.07)
    lo = max(0, cx - half)
    bys, bxs = np.nonzero(m[:, lo:cx + half])
    if len(bxs) < 10:
        return 90.0
    _, vecs = np.linalg.eigh(np.cov(np.vstack([bxs, bys])))
    vx, vy = vecs[:, 1]
    return float(np.degrees(np.arctan(abs(vx) / max(abs(vy), 1e-9))))


def body_centre(m):
    """(centre, length) of the body along a narrow vertical band through the
    middle, as animate.body_axis measures it: the wing pose barely moves it."""
    ys, xs = np.nonzero(m)
    cx = int(np.median(xs))
    half = max(2, int(m.shape[1] * 0.04))
    rows = np.nonzero(m[:, max(0, cx - half):cx + half].any(axis=1))[0]
    return np.array([float(cx), (rows.min() + rows.max()) / 2]), max(rows.max() - rows.min(), 1)


def score_clip(clip):
    fs = frames(clip)
    cyc = cycle_length(clip)
    masks = [mask(f) for f in fs[:cyc + 1]]
    if any(not m.any() for m in masks):
        return {"cycle": int(cyc), "empty": True, "pass": False}
    centre0, length0 = body_centre(masks[0])
    area0 = masks[0].sum()
    tilt = max(body_tilt(m) for m in masks)
    drift = max(np.hypot(*(body_centre(m)[0] - centre0)) for m in masks) / length0
    motion = max((masks[0] ^ m).sum() / area0 for m in masks[1:])
    thumbs = [thumb(f) for f in fs[:cyc + 1]]
    step = np.median([np.abs(thumbs[i] - thumbs[i + 1]).mean() for i in range(cyc)])
    loop = np.abs(thumbs[0] - thumbs[cyc]).mean() / max(step, 1e-6)
    out = {"cycle": int(cyc), "tilt": round(tilt, 1), "drift": round(float(drift), 3), "motion": round(float(motion), 2),
           "loop": round(float(loop), 2)}
    out["pass"] = bool(tilt <= MAX_TILT and drift <= MAX_DRIFT and motion >= MIN_MOTION)
    out["rank"] = round(float(loop + tilt / MAX_TILT + drift / MAX_DRIFT), 2)  # lower is better
    return out


def load_score(clip):
    path = clip / "score.json"
    if not path.exists() or path.stat().st_mtime < (clip / "f_00.png").stat().st_mtime:
        path.write_text(json.dumps(score_clip(clip)))
    return json.loads(path.read_text())


def verdicts():
    return json.loads(VERDICTS.read_text()) if VERDICTS.exists() else {}


def accepted_clip(sid):
    """The clip to cut for a skin: the best one a reviewer marked ok, else the
    best one that passes the numbers and no one turned down; None if none."""
    v = verdicts().get(sid, {})
    clips = [c for c in clip_dirs(sid) if v.get(c.name, {}).get("ok") is not False]
    ok = [c for c in clips if v.get(c.name, {}).get("ok")]
    pool = ok or [c for c in clips if load_score(c)["pass"]]
    return min(pool, key=lambda c: load_score(c).get("rank", 99), default=None)


def sheet(sid, cell=96):
    clips = clip_dirs(sid)
    if not clips:
        return None
    label_w = 230
    im = Image.new("RGB", (label_w + cell * (MAX_CYCLE + 1), cell * len(clips)), "white")
    draw = ImageDraw.Draw(im)
    for r, clip in enumerate(clips):
        s = load_score(clip)
        for i, f in enumerate(frames(clip)[:s["cycle"] + 1]):
            im.paste(Image.open(f).convert("RGB").resize((cell, cell)), (label_w + i * cell, r * cell))
        text = f"{clip.name}\n" + ("EMPTY" if s.get("empty") else
                                   f"tilt {s['tilt']}  drift {s['drift']}\nmotion {s['motion']}  loop {s['loop']}\n"
                                   f"cycle {s['cycle']}  {'PASS' if s['pass'] else 'fail'}")
        draw.multiline_text((4, r * cell + 4), text, fill="black")
    dest = WAN / "sheets" / f"{sid}.png"
    dest.parent.mkdir(exist_ok=True)
    im.save(dest)
    return dest


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    if "--out" in sys.argv:
        set_root(sys.argv[sys.argv.index("--out") + 1])
    if sys.argv[1] == "all":
        ids = sorted(d.name for d in WAN.iterdir() if d.is_dir() and d.name != "sheets")
    else:
        ids = PILOT if sys.argv[1] == "pilot" else sys.argv[1].split(",")
    v = verdicts()
    for sid in ids:
        migrate_legacy(sid)
        best = accepted_clip(sid)
        for clip in clip_dirs(sid):
            s = load_score(clip)
            mark = "*" if clip == best else " "
            seen = {True: "ok", False: "bad"}.get(v.get(sid, {}).get(clip.name, {}).get("ok"), "")
            print(f"{mark} {sid:14} {clip.name:18} " + ("EMPTY" if s.get("empty") else
                  f"cyc {s['cycle']:2} tilt {s['tilt']:5.1f} drift {s['drift']:.2f} motion {s['motion']:.2f} "
                  f"loop {s['loop']:.2f} {'PASS' if s['pass'] else 'fail':4} {seen}"))
        if "--sheets" in sys.argv:
            sheet(sid)


if __name__ == "__main__":
    main()
