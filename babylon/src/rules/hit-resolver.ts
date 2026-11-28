// lib/game/logic/hit_resolver.dart: which target, if any, a shot hit (§3.2, §3.3).
import { hitRadiusFor, inputLatencyS, type GameConfig } from './game-config';
import { dist, vec, type Vec } from './vec';

export interface HitTarget {
  readonly hittable: boolean;
  readonly spriteRadius: number;
  positionAt(time: number, out?: Vec): Vec;
}

export interface HitResult<T extends HitTarget> {
  target: T;
  /** Inside the sprite itself, not only inside the forgiving ring. */
  precise: boolean;
  distance: number;
  center: Vec;
}

/** Distances closer than this count as a tie; on a tie the bigger target wins. */
export const TIE_EPSILON = 0.5;

export class HitResolver<T extends HitTarget> {
  constructor(private readonly config: GameConfig, private readonly targets: () => Iterable<T>) {}

  resolve(shot: Vec, shotTime: number): HitResult<T> | null {
    const time = shotTime - inputLatencyS(this.config);
    let best: T | null = null;
    let bestDistance = Infinity;
    let bestCenter: Vec | null = null;
    for (const target of this.targets()) {
      if (!target.hittable) continue;
      const center = target.positionAt(time, vec());
      const distance = dist(shot, center);
      if (distance > hitRadiusFor(this.config, target.spriteRadius)) continue;
      const closer = distance < bestDistance - TIE_EPSILON;
      const tiedButBigger = Math.abs(distance - bestDistance) <= TIE_EPSILON && best !== null && target.spriteRadius > best.spriteRadius;
      if (best === null || closer || tiedButBigger) {
        best = target;
        bestDistance = distance;
        bestCenter = center;
      }
    }
    if (best === null || bestCenter === null) return null;
    return { target: best, precise: bestDistance <= best.spriteRadius, distance: bestDistance, center: bestCenter };
  }
}
