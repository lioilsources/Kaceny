import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

/// Recognises the reload gesture: a downward swipe anywhere (§3.4).
///
/// Tracks every pointer separately. A pointer fires once, as soon as it has
/// travelled [minDistance] within [maxAngleRad] of straight down — no need to
/// wait for the finger to lift.
class ReloadSwipeDetector {
  ReloadSwipeDetector({required this.minDistance, required this.maxAngleRad});

  final double minDistance;
  final double maxAngleRad;

  final Map<int, Vector2> _starts = {};
  final Set<int> _fired = {};

  void down(int pointer, Vector2 position) {
    _starts[pointer] = position.clone();
    _fired.remove(pointer);
  }

  /// True when this move completes a reload swipe.
  bool move(int pointer, Vector2 position) {
    final start = _starts[pointer];
    if (start == null || _fired.contains(pointer)) {
      return false;
    }
    if (!isReloadSwipe(position - start)) {
      return false;
    }
    _fired.add(pointer);
    return true;
  }

  void up(int pointer) {
    _starts.remove(pointer);
    _fired.remove(pointer);
  }

  void clear() {
    _starts.clear();
    _fired.clear();
  }

  bool isReloadSwipe(Vector2 delta) {
    if (delta.y <= 0 || delta.length < minDistance) {
      return false;
    }
    return math.atan2(delta.x.abs(), delta.y) <= maxAngleRad;
  }
}
