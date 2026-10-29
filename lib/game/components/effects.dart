import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show TextPainter, TextSpan, TextStyle, FontWeight, Shadow, TextDirection;

import '../render/palette.dart';

/// Expanding ring where a shot landed: instant feedback for every tap.
class ImpactFx extends PositionComponent {
  ImpactFx(Vector2 at, {this.hit = false}) : super(position: at, priority: 70);

  final bool hit;
  double _t = 0;
  static const _life = 0.22;
  final _paint = Paint()..style = PaintingStyle.stroke;

  @override
  void update(double dt) {
    _t += dt;
    if (_t >= _life) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final k = (_t / _life).clamp(0.0, 1.0);
    _paint
      ..strokeWidth = 3 * (1 - k) + 0.5
      ..color = (hit ? Palette.popupPrecise : Palette.hitRing).withValues(alpha: 0.9 * (1 - k));
    canvas.drawCircle(Offset.zero, 6 + 18 * k, _paint);
  }
}

/// "+12" floating up from a hit, golden for a precise one.
class ScorePopup extends PositionComponent {
  ScorePopup(Vector2 at, int points, {required bool precise, double multiplier = 1})
    : _painter = TextPainter(
        text: TextSpan(
          text: '+$points${multiplier > 1 ? ' ×${_fmt(multiplier)}' : ''}${precise ? '!' : ''}',
          style: TextStyle(
            color: precise ? Palette.popupPrecise : Palette.popup,
            fontSize: precise ? 24 : 20,
            fontWeight: FontWeight.w900,
            shadows: const [Shadow(color: Color(0xAA000000), blurRadius: 3, offset: Offset(0, 1))],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(),
      super(position: at, priority: 80);

  static String _fmt(double m) => m == m.roundToDouble() ? m.toStringAsFixed(0) : m.toStringAsFixed(1);

  final TextPainter _painter;
  double _t = 0;
  static const _life = 0.8;

  @override
  void update(double dt) {
    _t += dt;
    position.y -= 50 * dt;
    if (_t >= _life) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final k = _t / _life;
    final alpha = k < 0.6 ? 1.0 : 1 - (k - 0.6) / 0.4;
    final scale = k < 0.12 ? 0.6 + k / 0.12 * 0.5 : 1.1 - math.min(0.1, (k - 0.12));
    canvas.save();
    canvas.scale(scale);
    final offset = Offset(-_painter.width / 2, -_painter.height / 2);
    canvas.saveLayer(offset & _painter.size, Paint()..color = Color.fromRGBO(0, 0, 0, alpha.clamp(0, 1)));
    _painter.paint(canvas, offset);
    canvas.restore();
    canvas.restore();
  }

  @override
  void onRemove() {
    _painter.dispose();
    super.onRemove();
  }
}

/// A puff of feathers where a duck was hit.
class FeatherBurst extends PositionComponent {
  FeatherBurst(Vector2 at, math.Random random, {int count = 7, double scale = 1})
    : _feathers = [
        for (var i = 0; i < count; i++)
          _Feather(
            dx: (random.nextDouble() - 0.5) * 160 * scale,
            dy: (-random.nextDouble() * 120 - 20) * scale,
            spin: (random.nextDouble() - 0.5) * 10,
            size: (5 + random.nextDouble() * 5) * scale,
            angle: random.nextDouble() * math.pi,
          ),
      ],
      super(position: at, priority: 75);

  final List<_Feather> _feathers;
  final _paint = Paint()..color = Palette.feather;
  double _t = 0;
  static const _life = 0.9;

  @override
  void update(double dt) {
    _t += dt;
    for (final f in _feathers) {
      f.x += f.dx * dt;
      f.y += f.dy * dt;
      f.dx *= math.pow(0.05, dt).toDouble();
      f.dy = f.dy * math.pow(0.1, dt).toDouble() + 140 * dt;
      f.angle += f.spin * dt + math.sin(_t * 8 + f.size) * 0.05;
    }
    if (_t >= _life) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final alpha = _t < _life * 0.6 ? 1.0 : 1 - (_t - _life * 0.6) / (_life * 0.4);
    _paint.color = Palette.feather.withValues(alpha: alpha.clamp(0, 1));
    for (final f in _feathers) {
      canvas.save();
      canvas.translate(f.x, f.y);
      canvas.rotate(f.angle);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: f.size * 0.45, height: f.size), _paint);
      canvas.restore();
    }
  }
}

class _Feather {
  _Feather({required this.dx, required this.dy, required this.spin, required this.size, required this.angle});

  double x = 0;
  double y = 0;
  double dx;
  double dy;
  final double spin;
  final double size;
  double angle;
}
