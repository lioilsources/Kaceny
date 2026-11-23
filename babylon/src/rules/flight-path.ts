// lib/game/logic/flight_path.dart: a duck's trajectory as a pure function of time since spawn.
import type { FlightPathKind } from './game-config';
import type { GameRandom } from './random';
import { setVec, vec, type Vec } from './vec';

export interface FlightShape {
  kind: FlightPathKind;
  startX: number;
  startY: number;
  /** Nominal downward speed, pt/s. */
  speed: number;
  minX: number;
  maxX: number;
  angle: number;
  amplitude: number;
  frequency: number;
  phase: number;
}

const DIVE_START = 0.5;
const DIVE_MAX = 1.8;
const DIVE_ACCEL = 1.6;
const DEG = Math.PI / 180;

export class FlightPath {
  constructor(readonly s: FlightShape) {}

  /** Picks one of [allowed] and randomises its shape (same draws, same order as Dart). */
  static random(random: GameRandom, allowed: readonly FlightPathKind[], startY: number, speed: number, minX: number, maxX: number): FlightPath {
    const kind = allowed[random.nextInt(allowed.length)];
    const width = Math.max(0, maxX - minX);
    const sign = random.nextBool() ? 1 : -1;
    const base = { kind, startY, speed, minX, maxX, angle: 0, amplitude: 0, frequency: 0, phase: 0 };
    switch (kind) {
      case 'straight':
        return new FlightPath({ ...base, startX: minX + random.nextDouble() * width });
      case 'diagonal': {
        const startX = minX + random.nextDouble() * width;
        return new FlightPath({ ...base, startX, angle: sign * (15 + random.nextDouble() * 20) * DEG });
      }
      case 'sine': {
        const amplitude = Math.min(width / 2, 30 + random.nextDouble() * 50);
        const startX = minX + amplitude + random.nextDouble() * (width - 2 * amplitude);
        const frequency = 0.6 + random.nextDouble() * 0.6;
        return new FlightPath({ ...base, startX, amplitude, frequency, phase: random.nextDouble() * 2 * Math.PI });
      }
      case 'dive': {
        const startX = minX + random.nextDouble() * width;
        return new FlightPath({ ...base, startX, angle: sign * (random.nextDouble() * 10) * DEG });
      }
    }
  }

  positionAt(t: number, out: Vec = vec()): Vec {
    const s = this.s;
    switch (s.kind) {
      case 'straight':
        return setVec(out, s.startX, s.startY + s.speed * t);
      case 'diagonal':
        return setVec(out, this.reflect(s.startX + s.speed * Math.sin(s.angle) * t), s.startY + s.speed * Math.cos(s.angle) * t);
      case 'sine': {
        const x = s.startX + s.amplitude * Math.sin(2 * Math.PI * s.frequency * t + s.phase) - s.amplitude * Math.sin(s.phase);
        return setVec(out, Math.min(Math.max(x, s.minX), Math.max(s.minX, s.maxX)), s.startY + s.speed * t);
      }
      case 'dive': {
        const d = this.diveDistance(t);
        return setVec(out, this.reflect(s.startX + d * Math.sin(s.angle)), s.startY + d * Math.cos(s.angle));
      }
    }
  }

  private diveDistance(t: number): number {
    const v0 = this.s.speed * DIVE_START;
    const a = this.s.speed * DIVE_ACCEL;
    const tCap = (this.s.speed * DIVE_MAX - v0) / a;
    if (t <= tCap) return v0 * t + 0.5 * a * t * t;
    const dCap = v0 * tCap + 0.5 * a * tCap * tCap;
    return dCap + this.s.speed * DIVE_MAX * (t - tCap);
  }

  /** Folds an unbounded x back into [minX, maxX] as if bouncing off the sides. */
  private reflect(x: number): number {
    const { minX, maxX } = this.s;
    const width = maxX - minX;
    if (width <= 0) return minX;
    const period = 2 * width;
    // Dart's % on doubles is Euclidean (never negative); JS % keeps the sign.
    let u = (x - minX) % period;
    if (u < 0) u += period;
    return minX + (u <= width ? u : period - u);
  }
}
