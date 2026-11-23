// The Flame world on Babylon: an orthographic camera in logical pt (x right, y down, so meshes sit
// at y = -pt), the backdrop as a Layer, every duck a plane with its painter frame as texture.
// The vector duck has 3 frames × 4 sizes: 12 textures painted once and shared.
import { Camera } from '@babylonjs/core/Cameras/camera';
import { FreeCamera } from '@babylonjs/core/Cameras/freeCamera';
import type { Engine } from '@babylonjs/core/Engines/engine';
import { Layer } from '@babylonjs/core/Layers/layer';
import { StandardMaterial } from '@babylonjs/core/Materials/standardMaterial';
import { DynamicTexture } from '@babylonjs/core/Materials/Textures/dynamicTexture';
import { Color3, Color4 } from '@babylonjs/core/Maths/math.color';
import { Vector3 } from '@babylonjs/core/Maths/math.vector';
import type { Mesh } from '@babylonjs/core/Meshes/mesh';
import { CreatePlane } from '@babylonjs/core/Meshes/Builders/planeBuilder';
import { Scene } from '@babylonjs/core/scene';

import { DUCK_KINDS, type DuckKind, type GameConfig } from '../rules/game-config';
import { FLAP_FRAMES, type Duck } from '../rules/round';
import { paintBackdrop } from '../ui/backdrop';
import { paintDuck } from '../ui/duck-paint';

/** Further away = hazier and drawn behind (duck_component.dart). */
const HAZE: Record<DuckKind, number> = { tiny: 0.45, small: 0.28, medium: 0.12, big: 0 };
const PRIORITY: Record<DuckKind, number> = { tiny: 10, small: 20, medium: 30, big: 40 };
/** Texture box around the duck centre, × heightPt: wings reach 0.62, beak 0.5. */
const BOX = 1.4;

interface DuckView {
  mesh: Mesh;
  mat: StandardMaterial;
  frame: number;
}

export class DuckScene {
  readonly scene: Scene;
  private readonly camera: FreeCamera;
  private readonly frames = new Map<DuckKind, DynamicTexture[]>();
  private readonly views = new Map<number, DuckView>();
  private readonly backdrop: Layer;
  private readonly backdropTex: DynamicTexture;
  private drawnFor = '';

  constructor(engine: Engine, config: GameConfig) {
    this.scene = new Scene(engine);
    this.scene.clearColor = new Color4(0.494, 0.784, 0.941, 1);
    this.camera = new FreeCamera('cam', new Vector3(0, 0, -100), this.scene);
    this.camera.mode = Camera.ORTHOGRAPHIC_CAMERA;
    this.camera.setTarget(new Vector3(0, 0, 0));
    this.backdropTex = new DynamicTexture('backdrop', { width: 4, height: 4 }, this.scene, false);
    this.backdrop = new Layer('backdrop', null, this.scene, true);
    this.backdrop.texture = this.backdropTex;
    const dpr = Math.min(2, devicePixelRatio);
    for (const kind of DUCK_KINDS) {
      const h = config.ducks[kind].heightPt;
      const px = Math.ceil(h * BOX * dpr);
      this.frames.set(kind, Array.from({ length: FLAP_FRAMES }, (_, f) => {
        const tex = new DynamicTexture(`duck-${kind}-${f}`, { width: px, height: px }, this.scene, true);
        tex.hasAlpha = true;
        const g = tex.getContext() as unknown as CanvasRenderingContext2D;
        g.clearRect(0, 0, px, px);
        g.setTransform(px / (h * BOX), 0, 0, px / (h * BOX), px / 2, px / 2);
        paintDuck(g, h, f, HAZE[kind]);
        tex.update();
        return tex;
      }));
    }
  }

  /** Viewport in pt; the camera shows exactly [0, w] × [0, h]. */
  fit(w: number, h: number, playBottom: number): void {
    this.camera.orthoLeft = 0;
    this.camera.orthoRight = w;
    this.camera.orthoTop = 0;
    this.camera.orthoBottom = -h;
    const key = `${w}x${h}`;
    if (key === this.drawnFor) return;
    this.drawnFor = key;
    const dpr = Math.min(2, devicePixelRatio);
    this.backdropTex.scaleTo(Math.round(w * dpr), Math.round(h * dpr));
    const g = this.backdropTex.getContext() as unknown as CanvasRenderingContext2D;
    g.setTransform(dpr, 0, 0, dpr, 0, 0);
    paintBackdrop(g, w, h, playBottom);
    this.backdropTex.update();
  }

  sync(ducks: readonly Duck[]): void {
    const alive = new Set<number>();
    for (const d of ducks) {
      alive.add(d.id);
      let v = this.views.get(d.id);
      if (!v) v = this.create(d);
      const frame = d.frame;
      if (frame !== v.frame) {
        v.frame = frame;
        v.mat.diffuseTexture = this.frames.get(d.kind)![frame];
      }
      v.mesh.position.set(d.position.x, -d.position.y, 0);
      // Flame angle is clockwise with y down; Babylon's z rotation is counter-clockwise with y up.
      v.mesh.rotation.z = -d.angle;
      v.mat.alpha = Math.max(0, Math.min(1, d.opacity));
      v.mesh.alphaIndex = d.state === 'falling' ? 45 : PRIORITY[d.kind];
    }
    for (const [id, v] of this.views) {
      if (alive.has(id)) continue;
      v.mesh.dispose();
      v.mat.dispose();
      this.views.delete(id);
    }
  }

  private create(d: Duck): DuckView {
    const size = d.spec.heightPt * BOX;
    const mesh = CreatePlane(`duck-${d.id}`, { size }, this.scene);
    const mat = new StandardMaterial(`duck-${d.id}`, this.scene);
    mat.disableLighting = true;
    mat.emissiveColor = Color3.White();
    mat.diffuseTexture = this.frames.get(d.kind)![0];
    mat.useAlphaFromDiffuseTexture = true;
    mat.backFaceCulling = false;
    mesh.material = mat;
    const v = { mesh, mat, frame: 0 };
    this.views.set(d.id, v);
    return v;
  }
}
