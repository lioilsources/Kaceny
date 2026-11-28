// Colours from the generated Dart palette (ARGB ints) as CSS strings.
import { PALETTE } from './generated/palette';

export type PaletteName = keyof typeof PALETTE;

export function argbToCss(argb: number, alpha = 1): string {
  const a = ((argb >>> 24) & 0xff) / 255;
  return `rgba(${(argb >>> 16) & 0xff}, ${(argb >>> 8) & 0xff}, ${argb & 0xff}, ${+(a * alpha).toFixed(4)})`;
}

export const css = (name: PaletteName, alpha = 1): string => argbToCss(PALETTE[name], alpha);

/** Color.lerp of two palette colours (RGB only, opaque). */
export function lerpCss(a: PaletteName, b: PaletteName, t: number): string {
  const ca = PALETTE[a];
  const cb = PALETTE[b];
  const ch = (shift: number): number => Math.round(((ca >>> shift) & 0xff) + ((((cb >>> shift) & 0xff) - ((ca >>> shift) & 0xff)) * t));
  return `rgb(${ch(16)}, ${ch(8)}, ${ch(0)})`;
}
