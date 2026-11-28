// One round of Kačeny without Flame: the pure part of lib/game/kaceny_game.dart (round flow,
// spawning, shooting, reload) and of components/duck_component.dart (flying, falling, escaping).
// Stepped by the game at a fixed rate; the view reads `ducks` and drains `events`.
// Not yet ported (F2): the edge duck, feathers/popups are only events here.
import { FlightPath } from './flight-path';
import { reloadS, reloadSwipeMaxAngleRad, spriteRadius, type DuckKind, type DuckSpec, type GameConfig } from './game-config';
import { HitResolver, type HitTarget } from './hit-resolver';
import { Magazine } from './magazine';
import { PositionHistory } from './position-history';
import type { GameRandom } from './random';
import { ReloadSwipeDetector } from './reload-swipe';
import { ScoreKeeper } from './score-keeper';
import { Spawner } from './spawner';
import { vec, type Vec } from './vec';

export type DuckState = 'flying' | 'falling' | 'escaping';
export type RoundPhase = 'playing' | 'paused' | 'over';

/** Painter frames of the vector duck (DuckPainter.frames). */
export const FLAP_FRAMES = 3;

export type RoundEvent =
  | { type: 'shot'; at: Vec; hit: false }
  | { type: 'shot'; at: Vec; hit: true; duck: Duck; gained: number; precise: boolean; multiplier: number }
  | { type: 'dry' }
  | { type: 'reload' }
  | { type: 'reloaded' }
  | { type: 'beep'; left: number }
  | { type: 'over' };

let nextId = 1;

export class Duck implements HitTarget {
  readonly id = nextId++;
  readonly spriteRadius: number;
  readonly history: PositionHistory;
  readonly position: Vec;
  state: DuckState = 'flying';
  angle = 0;
  opacity = 1;
  removed = false;
  private age = 0;
  private stateTime = 0;
  private readonly flapRate: number;
  private readonly flapOffset: number;
  private readonly prev = vec();
  private heading = 0;
  private readonly velocity = vec();
  private spin = 0;

  constructor(readonly kind: DuckKind, readonly spec: DuckSpec, readonly path: FlightPath, private readonly config: GameConfig, random: GameRandom) {
    this.flapRate = 7 + random.nextDouble() * 3;
    this.flapOffset = random.nextDouble() * 3;
    this.spriteRadius = spriteRadius(spec);
    this.history = new PositionHistory(config.historySize);
    this.position = path.positionAt(0);
  }

  get hittable(): boolean { return this.state === 'flying'; }
  get points(): number { return this.spec.points; }

  /** Painter frame: wing beat while alive, level wings while falling. */
  get frame(): number {
    return this.state === 'falling' ? 1 : Math.floor((this.age + this.flapOffset) * this.flapRate) % FLAP_FRAMES;
  }

  positionAt(time: number, out?: Vec): Vec {
    if (this.history.isEmpty) return { x: this.position.x, y: this.position.y };
    return this.history.sample(time, out);
  }

  update(dt: number, clock: number, playBottom: number): void {
    this.stateTime += dt;
    if (this.state === 'falling') {
      this.velocity.y += this.config.fallGravity * dt;
      this.position.x += this.velocity.x * dt;
      this.position.y += this.velocity.y * dt;
      this.angle += this.spin * dt;
      const t = this.stateTime / this.config.fallDurationS;
      this.opacity = t < 0.7 ? 1 : 1 - (t - 0.7) / 0.3;
      if (t >= 1) this.removed = true;
    } else {
      this.age += dt;
      this.prev.x = this.position.x;
      this.prev.y = this.position.y;
      this.path.positionAt(this.age, this.position);
      const dx = this.position.x - this.prev.x;
      const dy = this.position.y - this.prev.y;
      if (dx * dx + dy * dy > 0.0001) {
        // Head points along the velocity; the painter's head is at +y.
        const target = Math.atan2(-dx, dy);
        this.heading += (target - this.heading) * Math.min(1, dt * 10);
        this.angle = this.heading;
      }
      if (this.state === 'flying' && this.position.y > playBottom - this.spriteRadius * 0.6) this.setState('escaping');
      if (this.state === 'escaping') {
        this.opacity = 1 - this.stateTime / this.config.escapeFadeS;
        if (this.opacity <= 0) this.removed = true;
      }
    }
    this.history.record(clock, this.position.x, this.position.y);
  }

  onShot(): void {
    this.setState('falling');
    // A little pop up, keep some sideways drift, tumble.
    this.velocity.x = (this.position.x - this.prev.x) * 20;
    this.velocity.y = -this.spec.heightPt * 2.5;
    this.spin = (this.velocity.x >= 0 ? 1 : -1) * (8 + this.spec.heightPt * 0.05);
  }

  private setState(s: DuckState): void {
    this.state = s;
    this.stateTime = 0;
  }
}

export interface RoundResult {
  score: number;
  shots: number;
  hits: number;
  bestStreak: number;
}

export class Round {
  readonly score: ScoreKeeper;
  readonly magazine: Magazine;
  readonly spawner: Spawner;
  readonly swipe: ReloadSwipeDetector;
  readonly resolver: HitResolver<Duck>;
  ducks: Duck[] = [];
  events: RoundEvent[] = [];
  phase: RoundPhase = 'playing';
  /** Game time, the time base of every position history. */
  clock = 0;
  /** Seconds into the round. */
  elapsed = 0;
  autoReload = false;
  private lastBeep = -1;
  private lastShotWall: number | null = null;

  constructor(readonly config: GameConfig, readonly random: GameRandom, public width: number, public height: number, public bottomInset = 0) {
    this.score = new ScoreKeeper(config);
    this.magazine = new Magazine(config.magazineSize, reloadS(config));
    this.spawner = new Spawner(config, random);
    this.swipe = new ReloadSwipeDetector(config.reloadSwipeMinPt, reloadSwipeMaxAngleRad(config));
    this.resolver = new HitResolver(config, () => this.ducks);
  }

  /** Lowest y a target may reach; below it is the ammo belt. */
  get playBottom(): number { return this.height - this.config.bottomSafeZonePt - this.bottomInset; }
  get timeLeft(): number { return Math.max(0, Math.ceil(this.config.roundSeconds - this.elapsed)); }
  get result(): RoundResult {
    const s = this.score;
    return { score: s.score, shots: s.shots, hits: s.hits, bestStreak: s.bestStreak };
  }

  restart(): void {
    this.ducks = [];
    this.events = [];
    this.score.reset();
    this.magazine.reset();
    this.spawner.reset();
    this.swipe.clear();
    this.elapsed = 0;
    this.lastBeep = -1;
    this.lastShotWall = null;
    this.phase = 'playing';
  }

  step(dt: number): void {
    if (this.phase !== 'playing') return;
    // Long hitches would teleport ducks (kaceny_game.dart caps dt the same way).
    dt = Math.min(dt, 1 / 20);
    this.clock += dt;
    this.elapsed += dt;
    if (this.magazine.update(dt)) this.events.push({ type: 'reloaded' });
    this.spawn(dt);
    const left = Math.ceil(this.config.roundSeconds - this.elapsed);
    if (left <= this.config.countdownSeconds && left > 0 && left !== this.lastBeep) {
      this.lastBeep = left;
      this.events.push({ type: 'beep', left });
    }
    for (const d of this.ducks) d.update(dt, this.clock, this.playBottom);
    this.ducks = this.ducks.filter((d) => !d.removed);
    if (this.elapsed >= this.config.roundSeconds) {
      this.phase = 'over';
      this.swipe.clear();
      this.events.push({ type: 'over' });
    }
  }

  private spawn(dt: number): void {
    const flying = this.ducks.filter((d) => d.state === 'flying').length;
    const plan = this.spawner.update(dt, this.elapsed, flying, false);
    for (const kind of plan.ducks) {
      const spec = this.config.ducks[kind];
      const r = spec.heightPt * 0.62; // wing reach
      const path = FlightPath.random(this.random, spec.paths, -spec.heightPt, this.spawner.speedFor(kind, this.elapsed), r, this.width - r);
      this.ducks.push(new Duck(kind, spec, path, this.config, this.random));
    }
  }

  // ---- Input -------------------------------------------------------------

  /**
   * Pointer down at [p] (pt). [wallMs] is the event time (cooldown), [sinceFrame] seconds since
   * the last step: the touch happened between frames, the clock only advances per step.
   */
  pointerDown(pointer: number, p: Vec, wallMs: number, sinceFrame: number): void {
    this.swipe.down(pointer, p);
    if (this.phase !== 'playing') return;
    if (p.y >= this.playBottom) {
      this.requestReload(); // the ammo belt: a tap there reloads, never shoots
      return;
    }
    this.shoot(p, wallMs, sinceFrame);
  }

  pointerMove(pointer: number, p: Vec): void {
    if (this.swipe.move(pointer, p) && this.phase === 'playing') this.requestReload();
  }

  pointerUp(pointer: number): void {
    this.swipe.up(pointer);
  }

  requestReload(): void {
    if (this.magazine.startReload()) this.events.push({ type: 'reload' });
  }

  private shoot(p: Vec, wallMs: number, sinceFrame: number): void {
    if (this.lastShotWall !== null && wallMs - this.lastShotWall < this.config.shotCooldownMs) return;
    this.lastShotWall = wallMs;
    if (!this.magazine.fire()) {
      this.events.push({ type: 'dry' });
      if (this.autoReload) this.requestReload();
      return;
    }
    const shotTime = this.clock + Math.min(sinceFrame, 1 / 30);
    const r = this.resolver.resolve(p, shotTime);
    if (r === null) {
      this.score.miss();
      this.events.push({ type: 'shot', at: p, hit: false });
    } else {
      const gained = this.score.hit(r.target.points, r.precise);
      r.target.onShot();
      this.events.push({ type: 'shot', at: p, hit: true, duck: r.target, gained, precise: r.precise, multiplier: this.score.multiplier });
    }
    if (this.magazine.empty && this.autoReload) this.requestReload();
  }
}
