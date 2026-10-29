import 'package:flutter/services.dart';

/// Haptic feedback (§3.5): light on a hit, medium on the edge duck, nothing
/// on a miss.
class Haptics {
  bool enabled = true;

  void hit() {
    if (enabled) {
      HapticFeedback.lightImpact();
    }
  }

  void bigHit() {
    if (enabled) {
      HapticFeedback.mediumImpact();
    }
  }
}
