// Entry point: one Babylon engine, the round stepped at a fixed rate, DOM HUD and an FX overlay.
// Port of lib/ui/game_screen.dart + kaceny_game.dart (F0 spike: vector skin, no menu, no sound).
// Deep links: ?debug shows FPS, ?seed=<n> repeats a round exactly.
import { Engine } from '@babylonjs/core/Engines/engine';

import { defaultConfig } from '../rules/game-config';
import { gameRandom } from '../rules/random';
import { Round } from '../rules/round';
import { showFps } from '../ui/fps';
import { FxLayer } from '../ui/fx';
import { byId, Hud, showGameOver } from '../ui/hud';
import { DuckScene } from './scene';
import '../ui/style.css';

const t0 = performance.now();
const params = new URLSearchParams(location.search);
const debug = params.has('debug');
const seed = params.get('seed');

const canvas = byId<HTMLCanvasElement>('game');
const engine = new Engine(canvas, true, { preserveDrawingBuffer: false, stencil: false });
engine.setHardwareScalingLevel(1 / Math.min(2, devicePixelRatio));
const config = defaultConfig;
const view = new DuckScene(engine, config);
const fx = new FxLayer(byId<HTMLCanvasElement>('fx'));
const hud = new Hud(config.bottomSafeZonePt);
const round = new Round(config, gameRandom(seed === null ? undefined : Number(seed)), canvas.clientWidth, canvas.clientHeight);

const resize = (): void => {
  engine.resize();
  round.width = canvas.clientWidth;
  round.height = canvas.clientHeight;
  view.fit(round.width, round.height, round.playBottom);
};
addEventListener('resize', resize);
resize();

// ---- Input: shots fire on pointer-down, no gesture delay (§3.1) -------------
let lastStep = performance.now();
const pt = (e: PointerEvent): { x: number; y: number } => {
  const r = canvas.getBoundingClientRect();
  return { x: e.clientX - r.left, y: e.clientY - r.top };
};
canvas.addEventListener('pointerdown', (e) => {
  canvas.setPointerCapture(e.pointerId);
  round.pointerDown(e.pointerId, pt(e), e.timeStamp, (performance.now() - lastStep) / 1000);
});
canvas.addEventListener('pointermove', (e) => round.pointerMove(e.pointerId, pt(e)));
const up = (e: PointerEvent): void => round.pointerUp(e.pointerId);
canvas.addEventListener('pointerup', up);
canvas.addEventListener('pointercancel', up);
addEventListener('keydown', (e) => {
  if (e.key === 'r' || e.key === 'R' || e.key === ' ') round.requestReload();
});

// ---- Loop -------------------------------------------------------------------
const STEP = 1 / 120;
let acc = 0;
let first = true;
const fpsEl = byId('fps');

function drainEvents(): void {
  for (const ev of round.events) {
    if (ev.type === 'shot') {
      fx.ring(ev.at.x, ev.at.y, ev.hit);
      if (ev.hit) fx.popup(ev.duck.position.x, ev.duck.position.y - ev.duck.spriteRadius - 8, ev.gained, ev.precise, ev.multiplier);
    } else if (ev.type === 'over') {
      const r = round.result;
      showGameOver(r.score, r.shots === 0 ? 0 : r.hits / r.shots, r.bestStreak, () => {
        fx.clear();
        round.restart();
      });
    }
  }
  round.events.length = 0;
}

engine.runRenderLoop(() => {
  const dt = Math.min(0.25, engine.getDeltaTime() / 1000);
  acc += dt;
  while (acc >= STEP) {
    round.step(STEP);
    acc -= STEP;
    lastStep = performance.now();
  }
  drainEvents();
  view.sync(round.ducks);
  fx.update(dt);
  fx.draw();
  const m = round.magazine;
  hud.update({
    timeLeft: round.timeLeft,
    countdown: round.timeLeft <= config.countdownSeconds,
    score: round.score.score,
    multiplier: round.score.multiplier,
    rounds: m.rounds,
    magazineSize: m.size,
    reloading: m.reloading,
    reloadProgress: m.reloadProgress,
  });
  view.scene.render();
  if (first && view.scene.isReady()) {
    first = false;
    console.info(`first frame ${((performance.now() - t0) / 1000).toFixed(2)} s`);
    (window as { __firstFrameMs?: number }).__firstFrameMs = performance.now(); // read by the F0 measurement
  }
  if (debug) showFps(fpsEl, engine.getFps());
});
