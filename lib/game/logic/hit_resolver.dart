import 'package:vector_math/vector_math.dart';

import '../../config/game_config.dart';

/// Anything a shot can hit.
abstract interface class HitTarget {
  /// False while falling, escaping or otherwise out of play.
  bool get hittable;

  /// Radius of the drawn sprite. A shot inside it is a precise hit.
  double get spriteRadius;

  /// Where the target's centre was at [time] (game clock, seconds).
  Vector2 positionAt(double time);
}

/// Outcome of a shot that hit something.
class HitResult<T extends HitTarget> {
  const HitResult({required this.target, required this.precise, required this.distance, required this.center});

  final T target;

  /// Inside the sprite itself (bonus), not only inside the forgiving ring.
  final bool precise;

  /// Distance from the shot to the target's centre at the compensated time.
  final double distance;

  /// The target's centre at the compensated time.
  final Vector2 center;

  @override
  String toString() => 'HitResult(precise: $precise, distance: ${distance.toStringAsFixed(1)})';
}

/// Decides which target, if any, a shot hit (§3.2, §3.3).
///
/// - Each target is a circle of `max(spriteRadius × hitboxScale, minHitRadius)`.
/// - It is tested where it was `inputLatencyMs` before the shot, interpolated
///   from its position history: the player aims at what they saw.
/// - Of all circles containing the shot, the one with the nearest centre wins;
///   on a tie the bigger (foreground) target wins.
class HitResolver<T extends HitTarget> {
  HitResolver({required this.config, required this._targets});

  final GameConfig config;
  final Iterable<T> Function() _targets;

  /// Distances closer than this count as a tie.
  static const tieEpsilon = 0.5;

  final Vector2 _scratch = Vector2.zero();

  HitResult<T>? resolve(Vector2 shotPoint, double shotTime) {
    final time = shotTime - config.inputLatencyS;
    T? best;
    var bestDistance = double.infinity;
    Vector2? bestCenter;
    for (final target in _targets()) {
      if (!target.hittable) {
        continue;
      }
      final center = target.positionAt(time);
      _scratch
        ..setFrom(shotPoint)
        ..sub(center);
      final distance = _scratch.length;
      if (distance > config.hitRadiusFor(target.spriteRadius)) {
        continue;
      }
      final closer = distance < bestDistance - tieEpsilon;
      final tiedButBigger =
          (distance - bestDistance).abs() <= tieEpsilon && best != null && target.spriteRadius > best.spriteRadius;
      if (best == null || closer || tiedButBigger) {
        best = target;
        bestDistance = distance;
        bestCenter = center.clone();
      }
    }
    if (best == null) {
      return null;
    }
    return HitResult(
      target: best,
      precise: bestDistance <= best.spriteRadius,
      distance: bestDistance,
      center: bestCenter!,
    );
  }
}
