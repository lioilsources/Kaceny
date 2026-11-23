// lib/game/components/effects.dart on a 2D overlay canvas: impact rings and score popups.
// Feathers come in F3. Drawn above the Babylon canvas, in pt.
import { css } from './palette';

interface Fx {
  kind: 'ring' | 'popup';
  x: number;
  y: number;
  t: number;
  hit: boolean;
  text: string;
  precise: boolean;
}

const RING_LIFE = 0.22;
const POPUP_LIFE = 0.8;
const fmt = (m: number): string => (m === Math.round(m) ? m.toFixed(0) : m.toFixed(1));

export class FxLayer {
  private readonly g: CanvasRenderingContext2D;
  private items: Fx[] = [];

  constructor(private readonly canvas: HTMLCanvasElement) {
    this.g = canvas.getContext('2d')!;
  }

  ring(x: number, y: number, hit: boolean): void {
    this.items.push({ kind: 'ring', x, y, t: 0, hit, text: '', precise: false });
  }

  popup(x: number, y: number, points: number, precise: boolean, multiplier: number): void {
    const text = `+${points}${multiplier > 1 ? ` ×${fmt(multiplier)}` : ''}${precise ? '!' : ''}`;
    this.items.push({ kind: 'popup', x, y, t: 0, hit: true, text, precise });
  }

  clear(): void {
    this.items = [];
  }

  update(dt: number): void {
    for (const f of this.items) {
      f.t += dt;
      if (f.kind === 'popup') f.y -= 50 * dt;
    }
    this.items = this.items.filter((f) => f.t < (f.kind === 'ring' ? RING_LIFE : POPUP_LIFE));
  }

  draw(): void {
    const { canvas, g } = this;
    const dpr = devicePixelRatio;
    const w = canvas.clientWidth;
    const h = canvas.clientHeight;
    if (canvas.width !== Math.round(w * dpr) || canvas.height !== Math.round(h * dpr)) {
      canvas.width = Math.round(w * dpr);
      canvas.height = Math.round(h * dpr);
    }
    g.setTransform(dpr, 0, 0, dpr, 0, 0);
    g.clearRect(0, 0, w, h);
    for (const f of this.items) {
      if (f.kind === 'ring') {
        const k = Math.min(1, f.t / RING_LIFE);
        g.lineWidth = 3 * (1 - k) + 0.5;
        g.strokeStyle = css(f.hit ? 'popupPrecise' : 'hitRing', 0.9 * (1 - k));
        g.beginPath();
        g.arc(f.x, f.y, 6 + 18 * k, 0, Math.PI * 2);
        g.stroke();
      } else {
        const k = f.t / POPUP_LIFE;
        const alpha = k < 0.6 ? 1 : 1 - (k - 0.6) / 0.4;
        const scale = k < 0.12 ? 0.6 + (k / 0.12) * 0.5 : 1.1 - Math.min(0.1, k - 0.12);
        g.save();
        g.translate(f.x, f.y);
        g.scale(scale, scale);
        g.globalAlpha = Math.max(0, Math.min(1, alpha));
        g.font = `900 ${f.precise ? 24 : 20}px system-ui, sans-serif`;
        g.textAlign = 'center';
        g.textBaseline = 'middle';
        g.shadowColor = 'rgba(0,0,0,0.67)';
        g.shadowBlur = 3;
        g.shadowOffsetY = 1;
        g.fillStyle = css(f.precise ? 'popupPrecise' : 'popup');
        g.fillText(f.text, 0, 0);
        g.restore();
      }
    }
  }
}
