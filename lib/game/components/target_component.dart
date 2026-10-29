import 'package:flame/components.dart';

import '../kaceny_game.dart';
import '../logic/hit_resolver.dart';
import '../logic/position_history.dart';

/// Base of everything that can be shot: keeps the position history the
/// [HitResolver] needs for lag compensation.
abstract class TargetComponent extends PositionComponent with HasGameReference<KacenyGame> implements HitTarget {
  TargetComponent({required this.spriteRadius, required int historySize, super.priority})
    : history = PositionHistory(historySize),
      super(anchor: Anchor.center);

  @override
  final double spriteRadius;

  final PositionHistory history;

  /// Points before precision bonus and combo.
  int get points;

  /// Bigger hit feedback (haptics, sound) for this target.
  bool get isBig => false;

  /// Called by the game when a shot hits this target.
  void onShot();

  /// Stores the current position under the game clock. Subclasses call this
  /// at the end of their update, after moving.
  void recordPosition() => history.record(game.clock, position.x, position.y);

  @override
  Vector2 positionAt(double time) => history.isEmpty ? position.clone() : history.sample(time);
}
