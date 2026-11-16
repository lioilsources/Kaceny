"""Build the wing-beat review page: every skin flapping at game speed.

    python3 tool/skins/build_review.py

Writes out/review/index.html and out/review/strips/<id>.webp (one horizontal
strip of frames per skin). Each skin shows what it would fly in the app
after this round: frames staged by wan_frames.py ("new"), else the frames
already in assets/ ("shipped"), else the single sprite squashed the way the
game fakes a beat ("static"). New skins carry their clip's numbers and any
warning. Publish the folder as an Artifact (index.html + strips/ as files)
with the `db` capability: viewers flip "Předělat" per skin, stored in the
collection `redo` as {redo: bool}, and those skins go to another round of
seeds (wan_flap.py, then mark the clip bad in out/wan/verdicts.json).
"""

import json
import sys
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from catalog import PACKS  # noqa: E402
from export_to_app import ASSETS  # noqa: E402
from wan_score import MAX_DRIFT, MAX_TILT, MIN_MOTION  # noqa: E402

OUT = HERE / "out" / "review"
STAGED = HERE / "out" / "staged"
TEMPLATE = HERE / "review_template.html"
CELL = 128
# A beat in the game lasts 3 / flap rate seconds, the rate drawn from 7-10.
BEAT_S = round(3 / 8.5, 3)
# The game's squash of a single sprite (DuckComponent._spriteFlap).
SPRITE_FLAP = [0.78, 1.0, 0.9]
NEAR = 0.8  # a number past this share of its limit counts as close


def numbered(paths):
    return sorted(paths, key=lambda p: int(p.stem.rsplit("_", 1)[-1]))


def source(sid):
    staged = numbered(STAGED.glob(f"{sid}/*.webp"))
    if staged:
        meta = json.loads((STAGED / sid / "source.json").read_text())
        return "new", staged, meta
    shipped = numbered(p for p in ASSETS.joinpath("duck").glob(f"{sid}_*.webp") if p.stem[len(sid) + 1:].isdigit())
    if shipped:
        return "shipped", shipped, None
    return "static", [ASSETS / "duck" / f"{sid}.png"], None


def flags(meta):
    if not meta:
        return []
    s = meta["score"]
    out = list(meta.get("warnings", []))
    if not s.get("pass"):
        out.append("neprošlo čísly, vybráno okem")
    if s.get("tilt", 0) > NEAR * MAX_TILT:
        out.append(f"náklon {s['tilt']}°")
    if s.get("drift", 0) > NEAR * MAX_DRIFT:
        out.append(f"posun {s['drift']}")
    if s.get("motion", 9) < MIN_MOTION / NEAR:
        out.append(f"málo pohybu {s['motion']}")
    if s.get("loop", 0) > 2.5:
        out.append(f"smyčka skáče ({s['loop']})")
    return out


def main():
    (OUT / "strips").mkdir(parents=True, exist_ok=True)
    packs = []
    for pack_id, (title, tier, items) in PACKS.items():
        skins = []
        for sid, name, _, _ in items:
            if not (ASSETS / "duck" / f"{sid}.png").exists():
                continue
            status, files, meta = source(sid)
            strip = Image.new("RGBA", (CELL * len(files), CELL), (0, 0, 0, 0))
            for i, f in enumerate(files):
                strip.paste(Image.open(f).convert("RGBA").resize((CELL, CELL), Image.LANCZOS), (i * CELL, 0))
            strip.save(OUT / "strips" / f"{sid}.webp", "WEBP", quality=90, method=6)
            entry = {"id": sid, "name": name, "status": status, "frames": len(files), "flags": flags(meta)}
            if meta:
                entry["clip"] = meta["clip"]
                entry["cycle"] = meta["cycle"]
            skins.append(entry)
        packs.append({"id": pack_id, "title": title.replace(" (zdarma)", ""), "free": tier == "free", "skins": skins})
    data = {"beat": BEAT_S, "cell": CELL, "squash": SPRITE_FLAP, "packs": packs}
    page = TEMPLATE.read_text().replace("/*DATA*/null", json.dumps(data, ensure_ascii=False))
    (OUT / "index.html").write_text(page)
    counts = {}
    for p in packs:
        for s in p["skins"]:
            counts[s["status"]] = counts.get(s["status"], 0) + 1
    print(f"{OUT / 'index.html'}: {counts}")


if __name__ == "__main__":
    main()
