// Mirrors test/logic/hit_resolver_test.dart (the Dart suite is the spec).
import { beforeEach, describe, expect, it } from 'vitest';
import { defaultConfig, type GameConfig } from '../src/rules/game-config';
import { HitResolver, type HitTarget } from '../src/rules/hit-resolver';
import { PositionHistory } from '../src/rules/position-history';
import type { Vec } from '../src/rules/vec';

class Fake implements HitTarget {
  readonly history = new PositionHistory(8);
  constructor(readonly name: string, readonly spriteRadius: number, public hittable = true) {}
  at(x: number, y: number): this {
    this.history.record(0, x, y);
    return this;
  }
  positionAt(t: number, out?: Vec): Vec {
    return this.history.sample(t, out);
  }
}

const noLag: GameConfig = { ...defaultConfig, inputLatencyMs: 0 };
let targets: Fake[];
let resolver: HitResolver<Fake>;
const p = (x: number, y: number): Vec => ({ x, y });

beforeEach(() => {
  targets = [];
  resolver = new HitResolver(noLag, () => targets);
});

it('no targets → null', () => expect(resolver.resolve(p(10, 10), 1)).toBeNull());

it('shot outside every hit circle → null', () => {
  targets.push(new Fake('a', 20).at(100, 100));
  expect(resolver.resolve(p(100, 127), 1)).toBeNull();
});

it('inside the sprite is a precise hit, the ring a plain one', () => {
  targets.push(new Fake('a', 20).at(100, 100));
  const r = resolver.resolve(p(110, 100), 1)!;
  expect([r.target.name, r.precise]).toEqual(['a', true]);
  expect(r.distance).toBeCloseTo(10, 9);
  expect(resolver.resolve(p(100, 124), 1)!.precise).toBe(false);
});

it('tiny sprites get the 22 pt minimum hit radius', () => {
  targets.push(new Fake('tiny', 12).at(100, 100));
  expect(resolver.resolve(p(121, 100), 1)?.precise).toBe(false);
  expect(resolver.resolve(p(123, 100), 1)).toBeNull();
});

it('overlapping circles: the nearest centre wins', () => {
  targets.push(new Fake('big', 40).at(100, 100), new Fake('small', 18).at(130, 100));
  expect(resolver.resolve(p(120, 100), 1)!.target.name).toBe('small');
  expect(resolver.resolve(p(112, 100), 1)!.target.name).toBe('big');
});

it('equal distance: the bigger target wins, order-independent', () => {
  targets.push(new Fake('small', 18).at(80, 100), new Fake('big', 40).at(120, 100));
  expect(resolver.resolve(p(100, 100), 1)!.target.name).toBe('big');
  targets.reverse();
  expect(resolver.resolve(p(100, 100), 1)!.target.name).toBe('big');
});

it('targets that are not hittable are ignored', () => {
  targets.push(new Fake('falling', 30, false).at(100, 100), new Fake('other', 30).at(140, 100));
  expect(resolver.resolve(p(100, 100), 1)).toBeNull();
  expect(resolver.resolve(p(125, 100), 1)!.target.name).toBe('other');
});

describe('lag compensation', () => {
  it('tests the position 60 ms before the shot', () => {
    const r60 = new HitResolver(defaultConfig, () => targets);
    const t = new Fake('duck', 18);
    for (let i = 0; i <= 12; i++) t.history.record(i / 60, 100, 300 * (i / 60));
    targets.push(t);
    const r = r60.resolve(p(100, 42), 0.2)!;
    expect(r.precise).toBe(true);
    expect(r.center.y).toBeCloseTo(42, 4);
  });
});
