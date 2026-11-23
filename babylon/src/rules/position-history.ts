// lib/game/logic/position_history.dart: ring buffer of (time, position) for lag compensation.
import { setVec, vec, type Vec } from './vec';

export class PositionHistory {
  private readonly t: Float64Array;
  private readonly x: Float64Array;
  private readonly y: Float64Array;
  private head = -1;
  private len = 0;

  constructor(readonly capacity: number) {
    if (capacity < 2) throw new Error('capacity >= 2');
    this.t = new Float64Array(capacity);
    this.x = new Float64Array(capacity);
    this.y = new Float64Array(capacity);
  }

  get length(): number { return this.len; }
  get isEmpty(): boolean { return this.len === 0; }

  /** Times must not decrease; a sample at the newest time replaces it. */
  record(time: number, x: number, y: number): void {
    if (this.len > 0 && time <= this.t[this.head]) {
      this.x[this.head] = x;
      this.y[this.head] = y;
      return;
    }
    this.head = (this.head + 1) % this.capacity;
    this.t[this.head] = time;
    this.x[this.head] = x;
    this.y[this.head] = y;
    if (this.len < this.capacity) this.len++;
  }

  clear(): void {
    this.head = -1;
    this.len = 0;
  }

  private index(i: number): number {
    return (this.head - this.len + 1 + i + this.capacity) % this.capacity;
  }

  /** Linear interpolation between the samples around [time]; clamped, never extrapolated. */
  sample(time: number, out: Vec = vec()): Vec {
    if (this.len === 0) throw new Error('PositionHistory.sample on an empty history');
    const set = (x: number, y: number): Vec => setVec(out, x, y);
    const oldest = this.index(0);
    if (time <= this.t[oldest]) return set(this.x[oldest], this.y[oldest]);
    if (time >= this.t[this.head]) return set(this.x[this.head], this.y[this.head]);
    for (let i = this.len - 1; i > 0; i--) {
      const a = this.index(i - 1);
      const b = this.index(i);
      if (time >= this.t[a]) {
        const span = this.t[b] - this.t[a];
        const f = span <= 0 ? 1 : (time - this.t[a]) / span;
        return set(this.x[a] + (this.x[b] - this.x[a]) * f, this.y[a] + (this.y[b] - this.y[a]) * f);
      }
    }
    return set(this.x[oldest], this.y[oldest]);
  }
}
