// lib/game/render/duck_painter.dart (DuckPainter) on Canvas 2D, 1:1: the vector duck seen from
// above, head to +y, drawn around its centre. Haze lerps every colour towards skyBottom.
import { lerpCss, type PaletteName } from './palette';

const WING_REACH = [0.4, 0.6, 0.5];
const WING_SWEEP = [-0.55, 0.0, 0.45];

export function paintDuck(g: CanvasRenderingContext2D, h: number, frame: number, haze: number): void {
  const c = (n: PaletteName): string => lerpCss(n, 'skyBottom', haze);
  const f = frame % 3;
  g.fillStyle = c('duckTail');
  g.beginPath();
  g.moveTo(-h * 0.1, -h * 0.3);
  g.lineTo(0, -h * 0.5);
  g.lineTo(h * 0.1, -h * 0.3);
  g.closePath();
  g.fill();
  for (const side of [-1, 1]) paintWing(g, side, WING_REACH[f] * h, WING_SWEEP[f], h, c);
  oval(g, 0, -h * 0.05, h * 0.34, h * 0.62, c('duckBody'));
  oval(g, 0, -h * 0.02, h * 0.16, h * 0.4, c('duckBelly'));
  oval(g, 0, h * 0.22, h * 0.2, h * 0.07, c('duckNeckRing'));
  g.fillStyle = c('duckHead');
  g.beginPath();
  g.arc(0, h * 0.31, h * 0.12, 0, Math.PI * 2);
  g.fill();
  g.fillStyle = c('beak');
  g.beginPath();
  g.moveTo(-h * 0.055, h * 0.39);
  g.quadraticCurveTo(-h * 0.06, h * 0.5, 0, h * 0.5);
  g.quadraticCurveTo(h * 0.06, h * 0.5, h * 0.055, h * 0.39);
  g.closePath();
  g.fill();
  g.strokeStyle = c('beakDark');
  g.lineWidth = Math.max(0.6, h * 0.012);
  g.beginPath();
  g.moveTo(0, h * 0.41);
  g.lineTo(0, h * 0.49);
  g.stroke();
  const eyeR = Math.max(0.8, h * 0.022);
  g.fillStyle = c('eye');
  for (const x of [-h * 0.085, h * 0.085]) {
    g.beginPath();
    g.arc(x, h * 0.33, eyeR, 0, Math.PI * 2);
    g.fill();
  }
}

function paintWing(g: CanvasRenderingContext2D, side: number, reach: number, sweep: number, h: number, c: (n: PaletteName) => string): void {
  g.save();
  g.translate(side * h * 0.12, -h * 0.06);
  g.rotate(side * sweep);
  g.fillStyle = c('duckWing');
  g.beginPath();
  g.moveTo(0, -h * 0.1);
  g.quadraticCurveTo(side * reach * 0.6, -h * 0.16, side * reach, -h * 0.02);
  g.quadraticCurveTo(side * reach * 0.55, h * 0.06, 0, h * 0.1);
  g.closePath();
  g.fill();
  g.fillStyle = c('duckWingTip');
  g.beginPath();
  g.moveTo(side * reach * 0.62, -h * 0.1);
  g.quadraticCurveTo(side * reach * 0.85, -h * 0.1, side * reach, -h * 0.02);
  g.quadraticCurveTo(side * reach * 0.8, h * 0.02, side * reach * 0.6, h * 0.04);
  g.closePath();
  g.fill();
  g.fillStyle = c('duckSpeculum');
  g.fillRect(side > 0 ? reach * 0.22 : -reach * 0.4, -h * 0.02, reach * 0.18, h * 0.05);
  g.restore();
}

function oval(g: CanvasRenderingContext2D, cx: number, cy: number, w: number, h: number, fill: string): void {
  g.fillStyle = fill;
  g.beginPath();
  g.ellipse(cx, cy, w / 2, h / 2, 0, 0, Math.PI * 2);
  g.fill();
}
