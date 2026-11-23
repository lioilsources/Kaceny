// Random sources. The game needs no parity with Dart's math.Random (the sequence is
// different anyway); golden vectors never depend on it, they pass explicit shapes.

/** What the rules draw from: dart:math Random's surface. */
export interface GameRandom {
  nextDouble(): number;
  nextInt(max: number): number;
  nextBool(): boolean;
}

/** Seeded LCG, bit-identical to the Dart `Lcg` in tool/dump_vectors.dart (Math.imul keeps it exact). */
export function lcg(seed: number): () => number {
  let s = Math.trunc(seed) & 0x7fffffff;
  return () => (s = (Math.imul(s, 1103515245) + 12345) & 0x7fffffff);
}

/** A GameRandom; seeded = repeatable (demo rides, tests), unseeded = Math.random. */
export function gameRandom(seed?: number): GameRandom {
  if (seed === undefined) {
    return {
      nextDouble: () => Math.random(),
      nextInt: (max) => Math.floor(Math.random() * max),
      nextBool: () => Math.random() < 0.5,
    };
  }
  const r = lcg(seed);
  const unit = (): number => r() / 0x80000000;
  return { nextDouble: unit, nextInt: (max) => Math.floor(unit() * max), nextBool: () => unit() < 0.5 };
}
