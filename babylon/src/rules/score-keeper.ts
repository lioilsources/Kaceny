// lib/game/logic/score_keeper.dart: points, combo and accuracy of one round (§4.4).
import type { GameConfig } from './game-config';

/** Dart's double.round(): half away from zero (Math.round rounds -2.5 to -2). */
export const dartRound = (v: number): number => Math.sign(v) * Math.round(Math.abs(v));

export class ScoreKeeper {
  score = 0;
  shots = 0;
  hits = 0;
  streak = 0;
  bestStreak = 0;

  constructor(readonly config: GameConfig) {}

  reset(): void {
    this.score = this.shots = this.hits = this.streak = this.bestStreak = 0;
  }

  get multiplier(): number { return this.multiplierFor(this.streak); }

  multiplierFor(streak: number): number {
    if (!this.config.comboEnabled) return 1;
    let m = 1;
    for (const tier of this.config.comboTiers) if (streak >= tier.hits) m = tier.multiplier;
    return m;
  }

  /** The hit counts toward the streak first, so the third hit in a row already gets ×1.5. */
  hit(points: number, precise: boolean): number {
    this.shots++;
    this.hits++;
    this.streak++;
    if (this.streak > this.bestStreak) this.bestStreak = this.streak;
    const gained = dartRound((points + (precise ? this.config.precisionBonus : 0)) * this.multiplier);
    this.score += gained;
    return gained;
  }

  /** No penalty, but the streak is gone. */
  miss(): void {
    this.shots++;
    this.streak = 0;
  }

  get accuracy(): number { return this.shots === 0 ? 0 : this.hits / this.shots; }
}
