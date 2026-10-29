# Sprite spec (replacing the vector placeholders)

v1 draws everything with vectors (`lib/game/render/duck_painter.dart`). Real
art from the ComfyUI pipeline should follow this spec so it drops in without
touching the gameplay numbers.

## Flying ducks (`assets/images/ducks/<kind>_<frame>.png`)

- Kinds: `tiny`, `small`, `medium`, `big` — or one master sprite scaled per
  kind (the game draws distant kinds hazier on its own).
- View: from above/behind, flying **down** the screen — head at the bottom of
  the image.
- 3 frames of wing flap: `0` wings up, `1` level, `2` down.
- Canvas: square, **beak-to-tail length = canvas height**; wing tips must stay
  within 62 % of the height from the centre (inside the hit circle).
- Anchor: centre of the canvas = centre of the body.
- Transparent PNG at @2x and @3x of the logical size:

  | kind   | logical (pt) | @2x  | @3x  |
  |--------|--------------|------|------|
  | tiny   | 24           | 48   | 72   |
  | small  | 36           | 72   | 108  |
  | medium | 52           | 104  | 156  |
  | big    | 80           | 160  | 240  |

  A single 256 × 256 master at 3 frames is also fine; it gets downscaled.

## Edge duck (`assets/images/ducks/edge_<state>.png`)

- A head and neck in profile, beak facing **right**, peeking up out of the
  bottom edge (neck continues to the bottom of the canvas); the game rotates
  and mirrors it for the other edges.
- Logical height 128 pt (head ≈ 92 pt across); canvas 128 × 256 pt so the
  neck is long enough to hide behind the edge.
- Anchor: head centre, at (50 %, 25 %) of the canvas.
- States: `idle`, `blink`, `dazed` (hit).

## Background (`assets/images/bg/`)

- Portrait, 1290 × 2796 px (iPhone Pro Max @3x), covers any aspect by
  cropping the sides. Optional parallax layers: `sky`, `hills`, `reeds`
  (reeds = transparent PNG, bottom-aligned, covers the bottom 15 %).
