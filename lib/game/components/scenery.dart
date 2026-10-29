import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';

import '../kaceny_game.dart';
import '../render/palette.dart';

/// Static landscape behind the ducks: sky, sun, distant hills, a pond.
/// Re-recorded into a [Picture] whenever the screen size changes.
class Background extends Component with HasGameReference<KacenyGame> {
  Background() : super(priority: -100);

  Picture? _picture;
  Vector2 _recordedFor = Vector2.zero();

  @override
  void render(Canvas canvas) {
    if (_picture == null || _recordedFor != game.size) {
      _picture?.dispose();
      _recordedFor = game.size.clone();
      _picture = _record(game.size.x, game.size.y, game.playBottom);
    }
    canvas.drawPicture(_picture!);
  }

  static Picture _record(double w, double h, double ground) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final sky = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRect(
      sky,
      Paint()..shader = Gradient.linear(Offset.zero, Offset(0, ground), [Palette.skyTop, Palette.skyBottom]),
    );
    canvas.drawCircle(Offset(w * 0.78, h * 0.16), w * 0.09, Paint()..color = Palette.sun);
    canvas.drawCircle(Offset(w * 0.78, h * 0.16), w * 0.16, Paint()..color = Palette.sun.withValues(alpha: 0.25));
    _hills(canvas, w, ground - h * 0.20, h * 0.06, 2.0, 0.3, Palette.hillFar);
    _hills(canvas, w, ground - h * 0.12, h * 0.05, 3.1, 1.7, Palette.hillMid);
    _hills(canvas, w, ground - h * 0.05, h * 0.03, 4.3, 0.9, Palette.hillNear);
    canvas.drawRect(Rect.fromLTWH(0, ground - h * 0.03, w, h), Paint()..color = Palette.water);
    return recorder.endRecording();
  }

  static void _hills(Canvas c, double w, double base, double amp, double freq, double phase, Color color) {
    final path = Path()..moveTo(0, base);
    for (var x = 0.0; x <= w; x += 4) {
      final u = x / w;
      path.lineTo(
        x,
        base -
            amp * (0.6 + 0.4 * math.sin(u * freq * math.pi + phase)) -
            amp * 0.3 * math.sin(u * freq * 3.1 + phase * 2),
      );
    }
    path
      ..lineTo(w, base + 2000)
      ..lineTo(0, base + 2000)
      ..close();
    c.drawPath(path, Paint()..color = color);
  }

  @override
  void onRemove() {
    _picture?.dispose();
    super.onRemove();
  }
}

/// Slow clouds drifting sideways, wrapping around.
class Clouds extends Component with HasGameReference<KacenyGame> {
  Clouds(this.random) : super(priority: -90);

  final math.Random random;
  final _clouds = <_Cloud>[];
  final _paint = Paint()..color = Palette.cloud.withValues(alpha: 0.85);

  @override
  void update(double dt) {
    if (_clouds.isEmpty && game.size.x > 0) {
      for (var i = 0; i < 5; i++) {
        _clouds.add(
          _Cloud(
            x: random.nextDouble() * game.size.x,
            y: game.size.y * (0.05 + random.nextDouble() * 0.5),
            scale: 0.6 + random.nextDouble() * 0.8,
            speed: 6 + random.nextDouble() * 10,
          ),
        );
      }
    }
    for (final c in _clouds) {
      c.x += c.speed * dt;
      if (c.x - 90 * c.scale > game.size.x) {
        c.x = -90 * c.scale;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    for (final c in _clouds) {
      final s = c.scale;
      canvas.drawOval(Rect.fromCenter(center: Offset(c.x, c.y), width: 120 * s, height: 34 * s), _paint);
      canvas.drawCircle(Offset(c.x - 22 * s, c.y - 10 * s), 20 * s, _paint);
      canvas.drawCircle(Offset(c.x + 12 * s, c.y - 16 * s), 26 * s, _paint);
    }
  }
}

class _Cloud {
  _Cloud({required this.x, required this.y, required this.scale, required this.speed});

  double x;
  final double y;
  final double scale;
  final double speed;
}

/// Reeds and cattails over the bottom HUD strip. Ducks that reach it vanish
/// behind them; the edge duck peeks out of them.
class Reeds extends Component with HasGameReference<KacenyGame> {
  Reeds(this.seed) : super(priority: 60);

  final int seed;
  Picture? _picture;
  Vector2 _recordedFor = Vector2.zero();
  double _recordedTop = 0;
  double _time = 0;

  @override
  void update(double dt) => _time += dt;

  @override
  void render(Canvas canvas) {
    if (_picture == null || _recordedFor != game.size || _recordedTop != game.playBottom) {
      _picture?.dispose();
      _recordedFor = game.size.clone();
      _recordedTop = game.playBottom;
      _picture = _record(game.size.x, game.size.y, game.playBottom);
    }
    // A gentle sway: shear the whole layer from its bottom.
    final sway = math.sin(_time * 1.3) * 0.015;
    canvas.save();
    canvas.translate(0, game.size.y);
    canvas.transform(Float64List.fromList([1, 0, 0, 0, sway, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]));
    canvas.translate(0, -game.size.y);
    canvas.drawPicture(_picture!);
    canvas.restore();
  }

  Picture _record(double w, double h, double top) {
    final random = math.Random(seed);
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(Rect.fromLTWH(0, top + 8, w, h - top), Paint()..color = Palette.reedDark);
    final blade = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < (w / 5).round(); i++) {
      final x = random.nextDouble() * w;
      final height = 14 + random.nextDouble() * 34;
      final lean = (random.nextDouble() - 0.5) * 14;
      blade
        ..color = Color.lerp(Palette.reedDark, Palette.reedLight, random.nextDouble())!
        ..strokeWidth = 2 + random.nextDouble() * 2.5;
      canvas.drawPath(
        Path()
          ..moveTo(x, h)
          ..lineTo(x, top + 14)
          ..quadraticBezierTo(x + lean * 0.4, top + 14 - height * 0.6, x + lean, top + 14 - height),
        blade,
      );
    }
    final stem = Paint()
      ..color = Palette.reedDark
      ..strokeWidth = 2;
    final head = Paint()..color = Palette.cattail;
    for (var i = 0; i < (w / 45).round(); i++) {
      final x = random.nextDouble() * w;
      final y = top - 6 - random.nextDouble() * 18;
      canvas.drawLine(Offset(x, h), Offset(x, y - 10), stem);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, y + 6), width: 7, height: 20),
          const Radius.circular(4),
        ),
        head,
      );
    }
    return recorder.endRecording();
  }

  @override
  void onRemove() {
    _picture?.dispose();
    super.onRemove();
  }
}
