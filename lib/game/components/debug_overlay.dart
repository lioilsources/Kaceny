import 'dart:ui';

import 'package:flame/components.dart';

import '../kaceny_game.dart';
import '../render/palette.dart';
import 'target_component.dart';

/// One shot as the debug overlay remembers it.
class DebugShot {
  DebugShot({required this.point, required this.compensated, required this.hit, required this.at});

  /// Where the finger came down.
  final Vector2 point;

  /// Each hittable target's current and lag-compensated centre at that time.
  final List<(Vector2 now, Vector2 then, double hitRadius)> compensated;
  final bool hit;
  final double at;
}

/// Debug builds only (Settings → Debug): hit circles (red), sprite circles
/// (green), shot points (cyan cross) and where each target was tested after
/// lag compensation (yellow), for tuning on the phone.
class DebugOverlay extends Component with HasGameReference<KacenyGame> {
  DebugOverlay() : super(priority: 100);

  final shots = <DebugShot>[];
  static const _keepS = 1.5;

  final _hit = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Palette.debugHit;
  final _sprite = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Palette.debugSprite;
  final _lag = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..color = Palette.debugLag;
  final _shot = Paint()
    ..strokeWidth = 2
    ..color = Palette.debugShot;
  final _zone = Paint()..color = Palette.debugHit.withValues(alpha: 0.12);

  void addShot(DebugShot shot) => shots.add(shot);

  @override
  void update(double dt) {
    shots.removeWhere((s) => game.clock - s.at > _keepS);
  }

  @override
  void render(Canvas canvas) {
    // Bottom dead zone.
    canvas.drawRect(Rect.fromLTRB(0, game.playBottom, game.size.x, game.size.y), _zone);
    for (final t in game.world.children.whereType<TargetComponent>()) {
      final c = Offset(t.position.x, t.position.y);
      canvas.drawCircle(c, game.config.hitRadiusFor(t.spriteRadius), _hit);
      canvas.drawCircle(c, t.spriteRadius, _sprite);
    }
    for (final s in shots) {
      final p = Offset(s.point.x, s.point.y);
      for (final (now, then, r) in s.compensated) {
        final a = Offset(then.x, then.y);
        canvas.drawLine(Offset(now.x, now.y), a, _lag);
        canvas.drawCircle(a, r, _lag);
      }
      _shot.color = s.hit ? Palette.debugSprite : Palette.debugShot;
      canvas.drawLine(p - const Offset(10, 0), p + const Offset(10, 0), _shot);
      canvas.drawLine(p - const Offset(0, 10), p + const Offset(0, 10), _shot);
    }
  }
}
