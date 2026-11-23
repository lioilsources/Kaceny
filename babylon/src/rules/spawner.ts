// lib/game/logic/spawner.dart: when and which ducks appear during a round (§4.3).
import { phaseAt, type DuckKind, type GameConfig, type PhaseSpec } from './game-config';
import type { GameRandom } from './random';

export interface SpawnPlan {
  ducks: DuckKind[];
  edgeDuck: boolean;
}

export const NO_SPAWN: SpawnPlan = Object.freeze({ ducks: [], edgeDuck: false }) as SpawnPlan;

export class Spawner {
  private sinceSpawn = 0;
  private edgeCountdown = 0;

  constructor(readonly config: GameConfig, readonly random: GameRandom) {
    this.reset();
  }

  reset(): void {
    // The first duck comes right away instead of after a full interval.
    this.sinceSpawn = this.config.phases[0].spawnIntervalS;
    this.edgeCountdown = this.config.edge.firstDelayS;
  }

  /** [elapsed] is round time after this step, [flying] the flying ducks alive. */
  update(dt: number, elapsed: number, flying: number, edgeActive: boolean): SpawnPlan {
    const phase = phaseAt(this.config, elapsed);
    const ducks: DuckKind[] = [];
    this.sinceSpawn += dt;
    let alive = flying;
    while (this.sinceSpawn >= phase.spawnIntervalS) {
      if (alive >= this.config.maxOnScreen) {
        // Full: wait for a free slot, then spawn immediately.
        this.sinceSpawn = phase.spawnIntervalS;
        break;
      }
      this.sinceSpawn -= phase.spawnIntervalS;
      ducks.push(this.pickKind(phase));
      alive++;
    }
    let edge = false;
    if (!edgeActive) {
      this.edgeCountdown -= dt;
      if (this.edgeCountdown <= 0) {
        edge = true;
        this.edgeCountdown = this.nextEdgeInterval();
      }
    }
    return ducks.length === 0 && !edge ? NO_SPAWN : { ducks, edgeDuck: edge };
  }

  nextEdgeInterval(): number {
    const e = this.config.edge;
    return e.minIntervalS + this.random.nextDouble() * (e.maxIntervalS - e.minIntervalS);
  }

  pickKind(phase: PhaseSpec): DuckKind {
    const total = phase.weights.reduce((a, [, w]) => a + w, 0);
    let roll = this.random.nextDouble() * total;
    for (const [kind, w] of phase.weights) {
      roll -= w;
      if (roll < 0) return kind;
    }
    return phase.weights[phase.weights.length - 1][0];
  }

  /** Random speed for [kind] within its range, scaled by the phase. */
  speedFor(kind: DuckKind, elapsed: number): number {
    const spec = this.config.ducks[kind];
    const base = spec.minSpeed + this.random.nextDouble() * (spec.maxSpeed - spec.minSpeed);
    return base * phaseAt(this.config, elapsed).speedScale;
  }
}
