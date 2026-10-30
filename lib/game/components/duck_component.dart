import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../../config/game_config.dart';
import '../logic/flight_path.dart';
import '../render/duck_painter.dart';
import '../render/palette.dart';
import 'target_component.dart';

enum DuckState { flying, falling, escaping }

/// A flying duck (§4.1–4.2): follows its [FlightPath] down the screen, falls
/// with gravity when shot, fades out when it reaches the bottom HUD line.
class DuckComponent extends TargetComponent {
  DuckComponent({
    required this.kind,
    required this.spec,
    required this.path,
    required this.config,
    required math.Random random,
    this.sprites,
  }) : _flapRate = 7 + random.nextDouble() * 3,
       _flapOffset = random.nextDouble() * 3,
       painter = DuckPainter(height: spec.heightPt, haze: _haze[kind]!),
       super(spriteRadius: spec.spriteRadius, historySize: config.historySize, priority: _priority[kind]) {
    path.positionAt(0, position);
    size = Vector2.all(spec.heightPt);
  }

  /// Further away = hazier and drawn behind.
  static const _haze = {DuckKind.tiny: 0.45, DuckKind.small: 0.28, DuckKind.medium: 0.12, DuckKind.big: 0.0};
  static const _priority = {DuckKind.tiny: 10, DuckKind.small: 20, DuckKind.medium: 30, DuckKind.big: 40};

  final DuckKind kind;
  final DuckSpec spec;
  final FlightPath path;
  final GameConfig config;
  final DuckPainter painter;

  /// The skin's duck pictures (head at the bottom): one wing beat in order,
  /// or a single one that gets squashed. Null = vector duck.
  final List<Image>? sprites;

  /// Fake wing beat for single-frame sprites: horizontal squash per frame.
  static const _spriteFlap = [0.78, 1.0, 0.9];

  final double _flapRate;
  final double _flapOffset;

  DuckState state = DuckState.flying;
  double _age = 0;
  double _stateTime = 0;
  double _opacity = 1;

  // Falling.
  final Vector2 _velocity = Vector2.zero();
  double _spin = 0;

  final Vector2 _prev = Vector2.zero();
  double _heading = 0;

  @override
  bool get hittable => state == DuckState.flying;

  @override
  int get points => spec.points;

  bool get flying => state == DuckState.flying;

  @override
  void onMount() {
    super.onMount();
    recordPosition();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _stateTime += dt;
    switch (state) {
      case DuckState.flying:
      case DuckState.escaping:
        _age += dt;
        _prev.setFrom(position);
        path.positionAt(_age, position);
        final dx = position.x - _prev.x;
        final dy = position.y - _prev.y;
        if (dx * dx + dy * dy > 0.0001) {
          // Head points along the velocity; the painter's head is at +y.
          final target = math.atan2(-dx, dy);
          _heading += (target - _heading) * math.min(1, dt * 10);
          angle = _heading;
        }
        if (state == DuckState.flying && position.y > game.playBottom - spriteRadius * 0.6) {
          _setState(DuckState.escaping);
        }
        if (state == DuckState.escaping) {
          _opacity = 1 - _stateTime / config.escapeFadeS;
          if (_opacity <= 0) {
            removeFromParent();
          }
        }
      case DuckState.falling:
        _velocity.y += config.fallGravity * dt;
        position.addScaled(_velocity, dt);
        angle += _spin * dt;
        final t = _stateTime / config.fallDurationS;
        _opacity = t < 0.7 ? 1 : 1 - (t - 0.7) / 0.3;
        if (t >= 1) {
          removeFromParent();
        }
    }
    recordPosition();
  }

  void _setState(DuckState s) {
    state = s;
    _stateTime = 0;
  }

  @override
  void onShot() {
    _setState(DuckState.falling);
    // A little pop up, keep some sideways drift, tumble.
    _velocity.setValues((position.x - _prev.x) * 20, -spec.heightPt * 2.5);
    _spin = (_velocity.x >= 0 ? 1 : -1) * (8 + spec.heightPt * 0.05);
    priority = 45;
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    final frame = state == DuckState.falling ? 1 : ((_age + _flapOffset) * _flapRate).floor() % DuckPainter.frames;
    final sprites = this.sprites;
    if (sprites == null) {
      painter.paint(canvas, frame, opacity: _opacity.clamp(0, 1));
    } else if (sprites.length > 1) {
      // A whole beat takes as long as the vector duck's three frames.
      final beat = state == DuckState.falling
          ? sprites.length ~/ 2
          : ((_age + _flapOffset) * _flapRate * sprites.length / DuckPainter.frames).floor() % sprites.length;
      _paintSprite(canvas, sprites[beat]);
    } else {
      canvas.scale(_spriteFlap[frame], 1);
      _paintSprite(canvas, sprites.first);
    }
    canvas.restore();
  }

  void _paintSprite(Canvas canvas, Image sprite) {
    final h = spec.heightPt;
    final paint = Paint()
      ..filterQuality = FilterQuality.medium
      ..color = Color.fromRGBO(255, 255, 255, _opacity.clamp(0, 1));
    // Half the vector haze: a sky-blue veil fights dark or busy skin backgrounds.
    final haze = _haze[kind]! * 0.5;
    if (haze > 0) {
      paint.colorFilter = ColorFilter.mode(Palette.skyBottom.withValues(alpha: haze), BlendMode.srcATop);
    }
    canvas.drawImageRect(
      sprite,
      Rect.fromLTWH(0, 0, sprite.width.toDouble(), sprite.height.toDouble()),
      Rect.fromCenter(center: Offset.zero, width: h, height: h),
      paint,
    );
  }
}
