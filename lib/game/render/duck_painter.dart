import 'dart:math' as math;
import 'dart:ui';

import 'palette.dart';

/// Vector placeholder ducks, seen from above while flying down the screen.
///
/// The duck is drawn around its centre, head pointing to +y (down). [height]
/// is the beak-to-tail length; wings stay inside 0.62 × height of the centre,
/// i.e. inside the hit circle. Three flap frames: 0 = wings up (foreshortened),
/// 1 = level, 2 = down.
class DuckPainter {
  DuckPainter({required this.height, this.haze = 0, this.hazeColor = Palette.skyBottom}) {
    Color c(Color base) => Color.lerp(base, hazeColor, haze)!;
    _head.color = c(Palette.duckHead);
    _ring.color = c(Palette.duckNeckRing);
    _body.color = c(Palette.duckBody);
    _belly.color = c(Palette.duckBelly);
    _wing.color = c(Palette.duckWing);
    _wingTip.color = c(Palette.duckWingTip);
    _speculum.color = c(Palette.duckSpeculum);
    _tail.color = c(Palette.duckTail);
    _beak.color = c(Palette.beak);
    _beakDark.color = c(Palette.beakDark);
    _eye.color = c(Palette.eye);
  }

  static const frames = 3;

  final double height;

  /// 0 = full colour, 1 = sky colour; distant ducks are hazier.
  final double haze;
  final Color hazeColor;

  final _head = Paint();
  final _ring = Paint();
  final _body = Paint();
  final _belly = Paint();
  final _wing = Paint();
  final _wingTip = Paint();
  final _speculum = Paint();
  final _tail = Paint();
  final _beak = Paint();
  final _beakDark = Paint();
  final _eye = Paint();

  /// Wing reach per frame as a fraction of [height].
  static const _wingReach = [0.40, 0.60, 0.50];

  /// Wing sweep (forward tilt of the tip) per frame, radians.
  static const _wingSweep = [-0.55, 0.0, 0.45];

  void paint(Canvas canvas, int frame, {double opacity = 1}) {
    final h = height;
    if (opacity < 1) {
      canvas.saveLayer(
        Rect.fromCircle(center: Offset.zero, radius: h),
        Paint()..color = Color.fromRGBO(0, 0, 0, opacity),
      );
    }
    final f = frame % frames;

    // Tail.
    final tail = Path()
      ..moveTo(-h * 0.10, -h * 0.30)
      ..lineTo(0, -h * 0.50)
      ..lineTo(h * 0.10, -h * 0.30)
      ..close();
    canvas.drawPath(tail, _tail);

    // Wings, mirrored.
    for (final side in const [-1.0, 1.0]) {
      _paintWing(canvas, side, _wingReach[f] * h, _wingSweep[f], h);
    }

    // Body and belly stripe.
    canvas.drawOval(Rect.fromCenter(center: Offset(0, -h * 0.05), width: h * 0.34, height: h * 0.62), _body);
    canvas.drawOval(Rect.fromCenter(center: Offset(0, -h * 0.02), width: h * 0.16, height: h * 0.40), _belly);

    // Neck ring, head, beak.
    canvas.drawOval(Rect.fromCenter(center: Offset(0, h * 0.22), width: h * 0.20, height: h * 0.07), _ring);
    canvas.drawCircle(Offset(0, h * 0.31), h * 0.12, _head);
    final beak = Path()
      ..moveTo(-h * 0.055, h * 0.39)
      ..quadraticBezierTo(-h * 0.06, h * 0.50, 0, h * 0.50)
      ..quadraticBezierTo(h * 0.06, h * 0.50, h * 0.055, h * 0.39)
      ..close();
    canvas.drawPath(beak, _beak);
    canvas.drawLine(Offset(0, h * 0.41), Offset(0, h * 0.49), _beakDark..strokeWidth = math.max(0.6, h * 0.012));
    final eyeR = math.max(0.8, h * 0.022);
    canvas.drawCircle(Offset(-h * 0.085, h * 0.33), eyeR, _eye);
    canvas.drawCircle(Offset(h * 0.085, h * 0.33), eyeR, _eye);

    if (opacity < 1) {
      canvas.restore();
    }
  }

  void _paintWing(Canvas canvas, double side, double reach, double sweep, double h) {
    canvas.save();
    canvas.translate(side * h * 0.12, -h * 0.06);
    canvas.rotate(side * sweep);
    final wing = Path()
      ..moveTo(0, -h * 0.10)
      ..quadraticBezierTo(side * reach * 0.6, -h * 0.16, side * reach, -h * 0.02)
      ..quadraticBezierTo(side * reach * 0.55, h * 0.06, 0, h * 0.10)
      ..close();
    canvas.drawPath(wing, _wing);
    final tip = Path()
      ..moveTo(side * reach * 0.62, -h * 0.10)
      ..quadraticBezierTo(side * reach * 0.85, -h * 0.10, side * reach, -h * 0.02)
      ..quadraticBezierTo(side * reach * 0.80, h * 0.02, side * reach * 0.60, h * 0.04)
      ..close();
    canvas.drawPath(tip, _wingTip);
    canvas.drawRect(
      Rect.fromLTWH(side > 0 ? reach * 0.22 : -reach * 0.40, -h * 0.02, reach * 0.18, h * 0.05),
      _speculum,
    );
    canvas.restore();
  }
}

/// The big duck that peeks in from a screen edge: a head in profile.
///
/// Drawn around the head centre, peeking "up" out of a bottom edge (its neck
/// continues to +y). The caller rotates the canvas for the other edges.
class EdgeDuckPainter {
  EdgeDuckPainter({required this.height});

  final double height;

  final _head = Paint()..color = Palette.duckHead;
  final _neck = Paint()..color = Palette.duckHead;
  final _ring = Paint()..color = Palette.duckNeckRing;
  final _beak = Paint()..color = Palette.beak;
  final _beakDark = Paint()..color = Palette.beakDark;
  final _eyeWhite = Paint()..color = Palette.eyeWhite;
  final _eye = Paint()..color = Palette.eye;
  final _shine = Paint()..color = Palette.eyeWhite;
  final _star = Paint()..color = Palette.beak;

  /// [facing] 1 = beak to the right, -1 = left. [blink] 0–1 closes the eye.
  /// [dazed] draws spiral eyes and stars (after being hit).
  void paint(Canvas canvas, {required double facing, double blink = 0, double dazed = 0, double time = 0}) {
    final h = height;
    final r = h * 0.36;
    // Neck down to the edge.
    canvas.drawRect(Rect.fromLTWH(-r * 0.62, 0, r * 1.24, h), _neck);
    canvas.drawRect(Rect.fromLTWH(-r * 0.66, r * 1.05, r * 1.32, h * 0.08), _ring);
    // Head.
    canvas.drawCircle(Offset.zero, r, _head);
    // Beak, wide and flat, pointing sideways.
    final beak = Path()
      ..moveTo(facing * r * 0.55, -r * 0.05)
      ..quadraticBezierTo(facing * r * 1.55, -r * 0.18, facing * r * 1.62, r * 0.18)
      ..quadraticBezierTo(facing * r * 1.35, r * 0.48, facing * r * 0.55, r * 0.36)
      ..close();
    canvas.drawPath(beak, _beak);
    canvas.drawLine(
      Offset(facing * r * 0.70, r * 0.17),
      Offset(facing * r * 1.50, r * 0.20),
      _beakDark..strokeWidth = r * 0.05,
    );
    // Eye.
    final eyeC = Offset(facing * r * 0.30, -r * 0.30);
    final eyeR = r * 0.30;
    canvas.drawCircle(eyeC, eyeR, _eyeWhite);
    if (dazed > 0) {
      final spiral = Paint()
        ..color = Palette.eye
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.05;
      final path = Path();
      for (var i = 0; i <= 40; i++) {
        final a = i / 40 * 4 * math.pi + time * 8;
        final rr = eyeR * 0.8 * i / 40;
        final p = eyeC + Offset(math.cos(a) * rr, math.sin(a) * rr);
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, spiral);
      for (var i = 0; i < 3; i++) {
        final a = time * 5 + i * 2 * math.pi / 3;
        _drawStar(canvas, Offset(math.cos(a) * r * 1.1, -r * 1.15 + math.sin(a) * r * 0.25), r * 0.16);
      }
    } else if (blink < 1) {
      final pupil = Rect.fromCenter(
        center: eyeC + Offset(facing * eyeR * 0.25, 0),
        width: eyeR * 1.0,
        height: eyeR * 1.1 * (1 - blink),
      );
      canvas.drawOval(pupil, _eye);
      canvas.drawCircle(eyeC + Offset(facing * eyeR * 0.40, -eyeR * 0.30), eyeR * 0.18, _shine);
    }
    if (blink > 0 && dazed == 0) {
      canvas.drawLine(
        eyeC - Offset(eyeR, 0),
        eyeC + Offset(eyeR, 0),
        Paint()
          ..color = Palette.eye
          ..strokeWidth = r * 0.06,
      );
    }
  }

  void _drawStar(Canvas canvas, Offset c, double r) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final a = -math.pi / 2 + i * math.pi / 5;
      final rr = i.isEven ? r : r * 0.45;
      final p = c + Offset(math.cos(a) * rr, math.sin(a) * rr);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path..close(), _star);
  }
}
