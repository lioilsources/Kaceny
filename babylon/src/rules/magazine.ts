// lib/game/logic/magazine.dart: the 8-round magazine and its reload (§3.4).
export class Magazine {
  rounds: number;
  /** Seconds left of a running reload; 0 when not reloading. */
  reloadLeft = 0;

  constructor(readonly size: number, readonly reloadS: number) {
    this.rounds = size;
  }

  get reloading(): boolean { return this.reloadLeft > 0; }
  get empty(): boolean { return this.rounds === 0; }
  get full(): boolean { return this.rounds === this.size; }
  get reloadProgress(): number { return this.reloading ? 1 - this.reloadLeft / this.reloadS : 0; }

  reset(): void {
    this.rounds = this.size;
    this.reloadLeft = 0;
  }

  /** Takes one round; false (a dry click) when empty or mid-reload. */
  fire(): boolean {
    if (this.reloading || this.rounds === 0) return false;
    this.rounds--;
    return true;
  }

  startReload(): boolean {
    if (this.reloading || this.full) return false;
    this.reloadLeft = this.reloadS;
    return true;
  }

  /** Advances the reload; true on the frame it finishes. */
  update(dt: number): boolean {
    if (!this.reloading) return false;
    this.reloadLeft -= dt;
    if (this.reloadLeft <= 0) {
      this.reloadLeft = 0;
      this.rounds = this.size;
      return true;
    }
    return false;
  }
}
