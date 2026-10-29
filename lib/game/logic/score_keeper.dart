import '../../config/game_config.dart';

/// Points, combo and accuracy of one round (§4.4).
class ScoreKeeper {
  ScoreKeeper(this.config);

  final GameConfig config;

  int score = 0;
  int shots = 0;
  int hits = 0;
  int streak = 0;
  int bestStreak = 0;

  void reset() {
    score = 0;
    shots = 0;
    hits = 0;
    streak = 0;
    bestStreak = 0;
  }

  /// Current multiplier from the hit streak; 1 with combos off.
  double get multiplier => multiplierFor(streak);

  double multiplierFor(int streak) {
    if (!config.comboEnabled) {
      return 1;
    }
    var m = 1.0;
    for (final tier in config.comboTiers) {
      if (streak >= tier.hits) {
        m = tier.multiplier;
      }
    }
    return m;
  }

  /// Records a hit and returns the points it was worth. The hit counts toward
  /// the streak first, so the third hit in a row already gets ×1.5.
  int hit({required int points, required bool precise}) {
    shots++;
    hits++;
    streak++;
    if (streak > bestStreak) {
      bestStreak = streak;
    }
    final base = points + (precise ? config.precisionBonus : 0);
    final gained = (base * multiplier).round();
    score += gained;
    return gained;
  }

  /// A shot that hit nothing: no penalty, but the streak is gone.
  void miss() {
    shots++;
    streak = 0;
  }

  /// Hits / shots in 0–1; 0 before the first shot.
  double get accuracy => shots == 0 ? 0 : hits / shots;
}
