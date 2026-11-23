// lib/config/game_config.dart. The numbers are not copied: tool/dump_vectors.dart writes every
// default into generated/game-config.json and CI fails when it drifts from the Dart source.
import json from './generated/game-config.json';

export type DuckKind = 'tiny' | 'small' | 'medium' | 'big';
export type FlightPathKind = 'straight' | 'diagonal' | 'sine' | 'dive';

export interface DuckSpec {
  heightPt: number;
  minSpeed: number;
  maxSpeed: number;
  points: number;
  paths: FlightPathKind[];
}

export interface EdgeDuckSpec {
  heightPt: number;
  points: number;
  minShowS: number;
  maxShowS: number;
  slideS: number;
  minIntervalS: number;
  maxIntervalS: number;
  firstDelayS: number;
  revealFraction: number;
}

export interface PhaseSpec {
  startS: number;
  spawnIntervalS: number;
  /** Insertion order matters (Spawner.pickKind walks it), hence pairs, not an object. */
  weights: [DuckKind, number][];
  speedScale: number;
}

export interface ComboTier {
  hits: number;
  multiplier: number;
}

export interface GameConfig {
  roundSeconds: number;
  countdownSeconds: number;
  shotCooldownMs: number;
  hitboxScale: number;
  minHitRadiusPt: number;
  inputLatencyMs: number;
  historySize: number;
  magazineSize: number;
  reloadMs: number;
  reloadSwipeMinPt: number;
  reloadSwipeMaxAngleDeg: number;
  bottomSafeZonePt: number;
  topHudPt: number;
  maxOnScreen: number;
  precisionBonus: number;
  comboEnabled: boolean;
  comboTiers: ComboTier[];
  fallDurationS: number;
  fallGravity: number;
  escapeFadeS: number;
  ducks: Record<DuckKind, DuckSpec>;
  phases: PhaseSpec[];
  edge: EdgeDuckSpec;
}

export const defaultConfig: GameConfig = json as GameConfig;

export const DUCK_KINDS = Object.keys(defaultConfig.ducks) as DuckKind[];

export const spriteRadius = (s: { heightPt: number }): number => s.heightPt / 2;
export const inputLatencyS = (c: GameConfig): number => c.inputLatencyMs / 1000;
export const reloadS = (c: GameConfig): number => c.reloadMs / 1000;
export const reloadSwipeMaxAngleRad = (c: GameConfig): number => (c.reloadSwipeMaxAngleDeg * Math.PI) / 180;

/** Hit circle radius for a sprite of [r]. */
export const hitRadiusFor = (c: GameConfig, r: number): number => Math.max(r * c.hitboxScale, c.minHitRadiusPt);

/** The phase active at [elapsedS] seconds into the round. */
export function phaseAt(c: GameConfig, elapsedS: number): PhaseSpec {
  let current = c.phases[0];
  for (const p of c.phases) if (elapsedS >= p.startS) current = p;
  return current;
}
