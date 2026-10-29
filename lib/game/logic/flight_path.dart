import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

import '../../config/game_config.dart';

/// A duck's trajectory as a pure function of time since spawn.
///
/// All paths head downwards; horizontal motion is kept inside [minX, maxX] so
/// the duck never leaves the screen sideways.
class FlightPath {
  FlightPath({
    required this.kind,
    required this.startX,
    required this.startY,
    required this.speed,
    required this.minX,
    required this.maxX,
    this.angle = 0,
    this.amplitude = 0,
    this.frequency = 0,
    this.phase = 0,
  });

  /// Picks one of [allowed] and randomises its shape.
  factory FlightPath.random({
    required math.Random random,
    required List<FlightPathKind> allowed,
    required double startY,
    required double speed,
    required double minX,
    required double maxX,
  }) {
    final kind = allowed[random.nextInt(allowed.length)];
    final width = math.max(0.0, maxX - minX);
    final sign = random.nextBool() ? 1.0 : -1.0;
    switch (kind) {
      case FlightPathKind.straight:
        return FlightPath(
          kind: kind,
          startX: minX + random.nextDouble() * width,
          startY: startY,
          speed: speed,
          minX: minX,
          maxX: maxX,
        );
      case FlightPathKind.diagonal:
        return FlightPath(
          kind: kind,
          startX: minX + random.nextDouble() * width,
          startY: startY,
          speed: speed,
          minX: minX,
          maxX: maxX,
          angle: sign * (15 + random.nextDouble() * 20) * math.pi / 180,
        );
      case FlightPathKind.sine:
        final amplitude = math.min(width / 2, 30 + random.nextDouble() * 50);
        return FlightPath(
          kind: kind,
          startX: minX + amplitude + random.nextDouble() * (width - 2 * amplitude),
          startY: startY,
          speed: speed,
          minX: minX,
          maxX: maxX,
          amplitude: amplitude,
          frequency: 0.6 + random.nextDouble() * 0.6,
          phase: random.nextDouble() * 2 * math.pi,
        );
      case FlightPathKind.dive:
        return FlightPath(
          kind: kind,
          startX: minX + random.nextDouble() * width,
          startY: startY,
          speed: speed,
          minX: minX,
          maxX: maxX,
          angle: sign * (random.nextDouble() * 10) * math.pi / 180,
        );
    }
  }

  final FlightPathKind kind;
  final double startX;
  final double startY;

  /// Nominal downward speed, pt/s.
  final double speed;
  final double minX;
  final double maxX;

  /// Diagonal / dive: deviation from vertical, radians, signed.
  final double angle;

  /// Sine: horizontal swing in pt and its frequency in Hz.
  final double amplitude;
  final double frequency;
  final double phase;

  /// Dive: starts at this fraction of [speed], accelerates up to [diveMax].
  static const diveStart = 0.5;
  static const diveMax = 1.8;
  static const diveAccel = 1.6; // × speed per second

  Vector2 positionAt(double t, [Vector2? out]) {
    final result = out ?? Vector2.zero();
    switch (kind) {
      case FlightPathKind.straight:
        return result..setValues(startX, startY + speed * t);
      case FlightPathKind.diagonal:
        final x = startX + speed * math.sin(angle) * t;
        return result..setValues(_reflect(x), startY + speed * math.cos(angle) * t);
      case FlightPathKind.sine:
        final x = startX + amplitude * math.sin(2 * math.pi * frequency * t + phase) - amplitude * math.sin(phase);
        return result..setValues(x.clamp(minX, math.max(minX, maxX)), startY + speed * t);
      case FlightPathKind.dive:
        final d = _diveDistance(t);
        final x = startX + d * math.sin(angle);
        return result..setValues(_reflect(x), startY + d * math.cos(angle));
    }
  }

  double _diveDistance(double t) {
    final v0 = speed * diveStart;
    final a = speed * diveAccel;
    final tCap = (speed * diveMax - v0) / a;
    if (t <= tCap) {
      return v0 * t + 0.5 * a * t * t;
    }
    final dCap = v0 * tCap + 0.5 * a * tCap * tCap;
    return dCap + speed * diveMax * (t - tCap);
  }

  /// Folds an unbounded x back into [minX, maxX] as if bouncing off the sides.
  double _reflect(double x) {
    final width = maxX - minX;
    if (width <= 0) {
      return minX;
    }
    final period = 2 * width;
    var u = (x - minX) % period;
    if (u < 0) {
      u += period;
    }
    return minX + (u <= width ? u : period - u);
  }
}
