// The round loop without a view: ducks spawn, fly, get shot and fall; the magazine runs dry.
import { describe, expect, it } from 'vitest';
import { defaultConfig } from '../src/rules/game-config';
import { gameRandom } from '../src/rules/random';
import { Round } from '../src/rules/round';

const STEP = 1 / 120;
const run = (r: Round, s: number): void => {
  for (let i = 0; i < Math.round(s / STEP); i++) r.step(STEP);
};

describe('Round', () => {
  it('spawns the first duck right away and keeps at most maxOnScreen flying', () => {
    const r = new Round(defaultConfig, gameRandom(1), 400, 850);
    r.step(STEP);
    expect(r.ducks.length).toBe(1);
    for (let i = 0; i < 20 * 120; i++) {
      r.step(STEP);
      expect(r.ducks.filter((d) => d.state === 'flying').length).toBeLessThanOrEqual(defaultConfig.maxOnScreen);
    }
  });

  it('a shot at a duck scores, the duck falls and is removed', () => {
    const r = new Round(defaultConfig, gameRandom(2), 400, 850);
    run(r, 1);
    const d = r.ducks.find((x) => x.state === 'flying')!;
    r.pointerDown(1, { x: d.position.x, y: d.position.y }, 1000, 0);
    const shot = r.events.find((e) => e.type === 'shot');
    expect(shot && shot.type === 'shot' && shot.hit).toBe(true);
    expect(r.score.score).toBeGreaterThan(0);
    expect(d.state).toBe('falling');
    run(r, defaultConfig.fallDurationS + 0.1);
    expect(r.ducks.includes(d)).toBe(false);
  });

  it('cooldown, dry click and a tap on the ammo belt reloading', () => {
    const r = new Round(defaultConfig, gameRandom(3), 400, 850);
    run(r, 0.1);
    r.pointerDown(1, { x: 5, y: 400 }, 0, 0);
    r.pointerDown(1, { x: 5, y: 400 }, 40, 0); // inside the 80 ms cooldown: ignored
    expect(r.magazine.rounds).toBe(defaultConfig.magazineSize - 1);
    for (let k = 1; k < defaultConfig.magazineSize; k++) r.pointerDown(1, { x: 5, y: 400 }, 1000 * k, 0);
    expect(r.magazine.empty).toBe(true);
    r.pointerDown(1, { x: 5, y: 400 }, 20000, 0);
    expect(r.events.some((e) => e.type === 'dry')).toBe(true);
    r.pointerDown(2, { x: 200, y: r.playBottom + 10 }, 21000, 0);
    expect(r.magazine.reloading).toBe(true);
    run(r, defaultConfig.reloadMs / 1000 + 0.05);
    expect(r.magazine.full).toBe(true);
  });

  it('a downward swipe reloads; the round ends after roundSeconds', () => {
    const r = new Round(defaultConfig, gameRandom(4), 400, 850);
    r.pointerDown(1, { x: 5, y: 300 }, 0, 0);
    r.pointerUp(1);
    r.pointerDown(2, { x: 100, y: 100 }, 1000, 0);
    r.pointerMove(2, { x: 105, y: 160 });
    expect(r.magazine.reloading).toBe(true);
    run(r, defaultConfig.roundSeconds + 0.1);
    expect(r.phase).toBe('over');
    expect(r.events.filter((e) => e.type === 'beep').length).toBe(defaultConfig.countdownSeconds);
  });
});
