// lib/ui/hud.dart as DOM: time and score on top, the ammo belt at the bottom (a tap there reloads,
// the round handles that). Pure view: the game passes numbers in.
export const byId = <T extends HTMLElement>(id: string): T => document.getElementById(id) as T;

export interface HudState {
  timeLeft: number;
  countdown: boolean;
  score: number;
  multiplier: number;
  rounds: number;
  magazineSize: number;
  reloading: boolean;
  reloadProgress: number;
}

export class Hud {
  private readonly time = byId('time');
  private readonly score = byId('score');
  private readonly mult = byId('mult');
  private readonly belt = byId('belt');
  private readonly reload = byId('reload');
  private last = '';

  constructor(bottomPt: number) {
    this.belt.style.height = `${bottomPt}px`;
  }

  update(s: HudState): void {
    const key = JSON.stringify([s.timeLeft, s.countdown, s.score, s.multiplier, s.rounds, s.reloading, s.reloading ? s.reloadProgress.toFixed(2) : 0]);
    if (key === this.last) return;
    this.last = key;
    this.time.textContent = `${Math.floor(s.timeLeft / 60)}:${String(s.timeLeft % 60).padStart(2, '0')}`;
    this.time.classList.toggle('hurry', s.countdown);
    this.score.textContent = String(s.score);
    this.mult.textContent = s.multiplier > 1 ? `×${s.multiplier}` : '';
    const shells = this.belt.querySelector('.shells')!;
    if (shells.childElementCount !== s.magazineSize) {
      shells.replaceChildren(...Array.from({ length: s.magazineSize }, () => document.createElement('i')));
    }
    [...shells.children].forEach((el, i) => el.classList.toggle('spent', i >= s.rounds));
    this.reload.hidden = !s.reloading;
    this.reload.style.setProperty('--p', String(s.reloadProgress));
  }
}

export function showGameOver(score: number, accuracy: number, bestStreak: number, again: () => void): void {
  const el = byId('over');
  byId('over-score').textContent = String(score);
  byId('over-stats').textContent = `přesnost ${Math.round(accuracy * 100)} % · nejdelší série ${bestStreak}`;
  el.hidden = false;
  byId('again').onclick = () => {
    el.hidden = true;
    again();
  };
}
