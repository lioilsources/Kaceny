// Replays the golden vectors written by tool/dump_vectors.dart (plan 06).
// Each test/golden/<name>.json is { "cases": [{ "in": …, "out": … }] }. Every file needs a
// replayer below and every replayer a file, so a vector set can't be silently skipped.
// Discrete values (ints, strings, bools) must match exactly (P0); floats to 1e-9 relative,
// which only tolerates last-bit libm differences between platforms.
import { readdirSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';
import { defaultConfig, reloadS, reloadSwipeMaxAngleRad } from '../src/rules/game-config';
import { FlightPath, type FlightShape } from '../src/rules/flight-path';
import { Magazine } from '../src/rules/magazine';
import { PositionHistory } from '../src/rules/position-history';
import { ReloadSwipeDetector } from '../src/rules/reload-swipe';
import { ScoreKeeper } from '../src/rules/score-keeper';

type Case = { in: unknown; out: unknown };

const REPLAY: Record<string, (input: never) => unknown> = {
  'flight-path.json': (shape: FlightShape) => {
    const p = new FlightPath(shape);
    return Array.from({ length: 31 }, (_, k) => {
      const v = p.positionAt(k * 0.1);
      return [v.x, v.y];
    });
  },
  'history.json': (i: { capacity: number; samples: [number, number, number][]; queries: number[] }) => {
    const h = new PositionHistory(i.capacity);
    for (const [t, x, y] of i.samples) h.record(t, x, y);
    return i.queries.map((q) => {
      const v = h.sample(q);
      return [v.x, v.y];
    });
  },
  'magazine.json': (ops: ('fire' | 'reload' | number)[]) => {
    const m = new Magazine(defaultConfig.magazineSize, reloadS(defaultConfig));
    return ops.map((o) => [o === 'fire' ? m.fire() : o === 'reload' ? m.startReload() : m.update(o), m.rounds, m.reloading]);
  },
  'score.json': (shots: { hit: boolean; points?: number; precise?: boolean }[]) => {
    const s = new ScoreKeeper(defaultConfig);
    const gained = shots.map((x) => (x.hit ? s.hit(x.points!, x.precise!) : (s.miss(), 0)));
    return { gained, score: s.score, shots: s.shots, hits: s.hits, bestStreak: s.bestStreak };
  },
  'swipe.json': ([dx, dy]: [number, number]) =>
    new ReloadSwipeDetector(defaultConfig.reloadSwipeMinPt, reloadSwipeMaxAngleRad(defaultConfig)).isReloadSwipe({ x: dx, y: dy }),
};

const dir = fileURLToPath(new URL('./golden/', import.meta.url));
const files = readdirSync(dir).filter((f) => f.endsWith('.json')).sort();
const EPS = 1e-9;

function same(actual: unknown, expected: unknown, path: string): void {
  if (typeof expected === 'number' && typeof actual === 'number') {
    if (Number.isInteger(expected) ? actual !== expected : Math.abs(actual - expected) > EPS * Math.max(1, Math.abs(expected))) {
      expect.fail(`${path}: ${actual} ≠ ${expected}`);
    }
  } else if (Array.isArray(expected)) {
    if (!Array.isArray(actual) || actual.length !== expected.length) expect.fail(`${path}: length ${JSON.stringify(actual)?.length} vs ${expected.length}`);
    expected.forEach((e, k) => same((actual as unknown[])[k], e, `${path}[${k}]`));
  } else if (expected !== null && typeof expected === 'object') {
    if (actual === null || typeof actual !== 'object') expect.fail(`${path}: not an object`);
    const keys = Object.keys(expected);
    expect(Object.keys(actual as object).sort(), `${path} keys`).toEqual([...keys].sort());
    for (const k of keys) same((actual as Record<string, unknown>)[k], (expected as Record<string, unknown>)[k], `${path}.${k}`);
  } else expect(actual, path).toEqual(expected);
}

describe('golden vectors', () => {
  it('every file has a replayer and every replayer a file', () => {
    expect(files).toEqual(Object.keys(REPLAY).sort());
  });
  for (const f of files) {
    it(f, () => {
      const { cases } = JSON.parse(readFileSync(dir + f, 'utf8')) as { cases: Case[] };
      expect(cases.length).toBeGreaterThan(0);
      // JSON has no int/double split: Dart writes 1.0 as 1, so an integral float compares exactly — fine for P0.
      cases.forEach((c, k) => same(REPLAY[f](c.in as never), c.out, `${f}#${k}`));
    });
  }
});
