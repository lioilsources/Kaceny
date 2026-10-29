import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../../config/game_config.dart';
import '../render/duck_painter.dart';
import 'target_component.dart';

enum ScreenEdge { left, right, top, bottom }

enum _EdgePhase { slideIn, show, slideOut, hit }

/// The big duck peeking in from a random edge (§4.1): slides in, looks
/// around for 0.8–1.5 s, slides back. The only target without a flight path.
class EdgeDuckComponent extends TargetComponent {
  EdgeDuckComponent({required this.spec, required GameConfig config, required math.Random random})
    : _random = random,
      edge = ScreenEdge.values[random.nextInt(ScreenEdge.values.length)],
      _facing = random.nextBool() ? 1 : -1,
      _showS = spec.minShowS + random.nextDouble() * (spec.maxShowS - spec.minShowS),
      painter = EdgeDuckPainter(height: spec.heightPt),
      super(spriteRadius: spec.spriteRadius * 0.72, historySize: config.historySize, priority: 50);

  final EdgeDuckSpec spec;
  final ScreenEdge edge;
  final EdgeDuckPainter painter;
  final math.Random _random;
  final double _facing;
  final double _showS;

  _EdgePhase _phase = _EdgePhase.slideIn;
  double _t = 0;
  double _life = 0;
  double _out = 0; // 0 = hidden, 1 = fully out

  /// Where along the edge it appears and the hidden/out positions.
  final Vector2 _hidden = Vector2.zero();
  final Vector2 _shown = Vector2.zero();
  Rect _clip = Rect.zero;

  @override
  bool get hittable => _phase != _EdgePhase.hit && _out > 0.25;

  @override
  int get points => spec.points;

  @override
  bool get isBig => true;

  bool get done => isRemoved || isRemoving;

  @override
  Future<void> onLoad() async {
    final area = game.edgeArea;
    _clip = area;
    final r = spec.heightPt * 0.36; // head radius as drawn
    final along = 0.2 + _random.nextDouble() * 0.6;
    // Head centre ends up revealFraction of the head height inside the edge.
    final inside = spec.revealFraction * 2 * r - r;
    final outside = r * 1.2;
    switch (edge) {
      case ScreenEdge.bottom:
        final x = area.left + area.width * along;
        _hidden.setValues(x, area.bottom + outside);
        _shown.setValues(x, area.bottom - inside);
        angle = 0;
      case ScreenEdge.top:
        final x = area.left + area.width * along;
        _hidden.setValues(x, area.top - outside);
        _shown.setValues(x, area.top + inside);
        angle = math.pi;
      case ScreenEdge.left:
        final y = area.top + area.height * along;
        _hidden.setValues(area.left - outside, y);
        _shown.setValues(area.left + inside, y);
        angle = math.pi / 2;
      case ScreenEdge.right:
        final y = area.top + area.height * along;
        _hidden.setValues(area.right + outside, y);
        _shown.setValues(area.right - inside, y);
        angle = -math.pi / 2;
    }
    position.setFrom(_hidden);
    recordPosition();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    _life += dt;
    switch (_phase) {
      case _EdgePhase.slideIn:
        _out = _ease(_t / spec.slideS);
        if (_t >= spec.slideS) {
          _next(_EdgePhase.show);
        }
      case _EdgePhase.show:
        _out = 1;
        if (_t >= _showS) {
          _next(_EdgePhase.slideOut);
        }
      case _EdgePhase.slideOut:
        _out = 1 - _ease(_t / spec.slideS);
        if (_t >= spec.slideS) {
          removeFromParent();
        }
      case _EdgePhase.hit:
        // Dazed for a moment, then drops back out of view, faster.
        const dazedS = 0.35;
        const dropS = 0.18;
        if (_t > dazedS) {
          _out = 1 - _ease((_t - dazedS) / dropS);
          if (_t >= dazedS + dropS) {
            removeFromParent();
          }
        }
    }
    position
      ..setFrom(_hidden)
      ..lerp(_shown, _out.clamp(0, 1));
    recordPosition();
  }

  void _next(_EdgePhase phase) {
    _phase = phase;
    _t = 0;
  }

  static double _ease(double t) {
    final x = t.clamp(0.0, 1.0);
    return 1 - math.pow(1 - x, 3).toDouble();
  }

  @override
  void onShot() => _next(_EdgePhase.hit);

  @override
  void renderTree(Canvas canvas) {
    // Clipped to the play area so the neck vanishes behind the screen edge,
    // the HUD bands and the reeds.
    canvas.save();
    canvas.clipRect(_clip);
    super.renderTree(canvas);
    canvas.restore();
  }

  @override
  void render(Canvas canvas) {
    // Blink once in a while; look shocked when hit.
    final blinkPhase = (_life * 1.3) % 2.2;
    final blink = blinkPhase < 0.12 ? math.sin(blinkPhase / 0.12 * math.pi) : 0.0;
    painter.paint(canvas, facing: _facing, blink: blink, dazed: _phase == _EdgePhase.hit ? 1 : 0, time: _life);
  }
}
