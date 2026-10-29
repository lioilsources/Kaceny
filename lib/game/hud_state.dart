import 'package:flutter/foundation.dart';

/// What the Flutter HUD shows, pushed by the game only when values change.
class HudState {
  HudState({int timeLeft = 90, int rounds = 8, this.magazineSize = 8})
    : timeLeft = ValueNotifier(timeLeft),
      rounds = ValueNotifier(rounds);

  final int magazineSize;
  final ValueNotifier<int> timeLeft;
  final score = ValueNotifier(0);
  final ValueNotifier<int> rounds;
  final reloading = ValueNotifier(false);
  final reloadProgress = ValueNotifier(0.0);
  final multiplier = ValueNotifier(1.0);

  /// The last seconds of the round: beeping, red timer.
  final countdown = ValueNotifier(false);
}
