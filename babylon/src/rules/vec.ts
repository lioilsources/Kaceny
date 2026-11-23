// The little of vector_math the rules use: plain {x, y} points in logical pt (y down).
export interface Vec {
  x: number;
  y: number;
}

/**
 * vector_math's Vector2 stores Float32List: every x/y written into one is rounded to float32,
 * while the arithmetic in between stays double. f32 marks those stores (golden vectors caught it).
 */
export const f32 = Math.fround;

/** A Vector2 with its components rounded like Dart's setValues. */
export const vec = (x = 0, y = 0): Vec => ({ x: f32(x), y: f32(y) });

/** Vector2.setValues. */
export function setVec(out: Vec, x: number, y: number): Vec {
  out.x = f32(x);
  out.y = f32(y);
  return out;
}
/** (a - b).length: the difference is stored as float32, the length is a double sqrt. */
export function dist(a: Vec, b: Vec): number {
  const dx = f32(a.x - b.x);
  const dy = f32(a.y - b.y);
  return Math.sqrt(dx * dx + dy * dy);
}
