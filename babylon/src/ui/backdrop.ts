// lib/game/components/scenery.dart (Background) on Canvas 2D: sky, sun, three hill bands, pond.
// Clouds and reeds come in F3.
import { css } from './palette';

export function paintBackdrop(g: CanvasRenderingContext2D, w: number, h: number, ground: number): void {
  const sky = g.createLinearGradient(0, 0, 0, ground);
  sky.addColorStop(0, css('skyTop'));
  sky.addColorStop(1, css('skyBottom'));
  g.fillStyle = sky;
  g.fillRect(0, 0, w, h);
  for (const [r, a] of [[0.09, 1], [0.16, 0.25]] as const) {
    g.fillStyle = css('sun', a);
    g.beginPath();
    g.arc(w * 0.78, h * 0.16, w * r, 0, Math.PI * 2);
    g.fill();
  }
  hills(g, w, ground - h * 0.2, h * 0.06, 2.0, 0.3, css('hillFar'));
  hills(g, w, ground - h * 0.12, h * 0.05, 3.1, 1.7, css('hillMid'));
  hills(g, w, ground - h * 0.05, h * 0.03, 4.3, 0.9, css('hillNear'));
  g.fillStyle = css('water');
  g.fillRect(0, ground - h * 0.03, w, h);
}

function hills(g: CanvasRenderingContext2D, w: number, base: number, amp: number, freq: number, phase: number, color: string): void {
  g.beginPath();
  g.moveTo(0, base);
  for (let x = 0; x <= w; x += 4) {
    const u = x / w;
    g.lineTo(x, base - amp * (0.6 + 0.4 * Math.sin(u * freq * Math.PI + phase)) - amp * 0.3 * Math.sin(u * freq * 3.1 + phase * 2));
  }
  g.lineTo(w, base + 2000);
  g.lineTo(0, base + 2000);
  g.closePath();
  g.fillStyle = color;
  g.fill();
}
