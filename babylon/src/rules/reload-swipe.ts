// lib/game/logic/reload_swipe.dart: a downward swipe anywhere reloads (§3.4).
import { dist, f32, type Vec } from './vec';

export class ReloadSwipeDetector {
  private readonly starts = new Map<number, Vec>();
  private readonly fired = new Set<number>();

  constructor(readonly minDistance: number, readonly maxAngleRad: number) {}

  down(pointer: number, p: Vec): void {
    this.starts.set(pointer, { x: f32(p.x), y: f32(p.y) });
    this.fired.delete(pointer);
  }

  /** True when this move completes a reload swipe (fires once per pointer, before lift). */
  move(pointer: number, p: Vec): boolean {
    const start = this.starts.get(pointer);
    if (!start || this.fired.has(pointer)) return false;
    if (!this.isReloadSwipe({ x: f32(p.x - start.x), y: f32(p.y - start.y) })) return false;
    this.fired.add(pointer);
    return true;
  }

  up(pointer: number): void {
    this.starts.delete(pointer);
    this.fired.delete(pointer);
  }

  clear(): void {
    this.starts.clear();
    this.fired.clear();
  }

  isReloadSwipe(d: Vec): boolean {
    if (d.y <= 0 || dist(d, { x: 0, y: 0 }) < this.minDistance) return false;
    return Math.atan2(Math.abs(d.x), d.y) <= this.maxAngleRad;
  }
}
