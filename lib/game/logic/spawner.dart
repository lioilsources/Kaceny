import 'dart:math' as math;

import '../../config/game_config.dart';

/// What the spawner asks the game to create this frame.
class SpawnPlan {
  const SpawnPlan({this.ducks = const [], this.edgeDuck = false});

  final List<DuckKind> ducks;
  final bool edgeDuck;

  static const none = SpawnPlan();
}

/// Decides when and which ducks appear during a round (§4.3).
///
/// Pure logic, stepped by the game: spawn interval and kind mix follow the
/// round's phase curve from [GameConfig.phases]; flying ducks are capped at
/// [GameConfig.maxOnScreen]; the edge duck comes every 8–12 s and never twice
/// at once.
class Spawner {
  Spawner({required this.config, required this.random}) {
    reset();
  }

  final GameConfig config;
  final math.Random random;

  double _sinceSpawn = 0;
  double _edgeCountdown = 0;

  void reset() {
    // The first duck comes right away instead of after a full interval.
    _sinceSpawn = config.phases.first.spawnIntervalS;
    _edgeCountdown = config.edge.firstDelayS;
  }

  /// Advances by [dt] seconds. [elapsed] is round time after this step,
  /// [flying] the number of flying ducks alive, [edgeActive] whether an edge
  /// duck is currently out.
  SpawnPlan update(double dt, {required double elapsed, required int flying, required bool edgeActive}) {
    final phase = config.phaseAt(elapsed);
    final ducks = <DuckKind>[];
    _sinceSpawn += dt;
    var alive = flying;
    while (_sinceSpawn >= phase.spawnIntervalS) {
      if (alive >= config.maxOnScreen) {
        // Full: wait for a free slot, then spawn immediately.
        _sinceSpawn = phase.spawnIntervalS;
        break;
      }
      _sinceSpawn -= phase.spawnIntervalS;
      ducks.add(pickKind(phase));
      alive++;
    }

    var edge = false;
    if (!edgeActive) {
      _edgeCountdown -= dt;
      if (_edgeCountdown <= 0) {
        edge = true;
        _edgeCountdown = nextEdgeInterval();
      }
    }
    if (ducks.isEmpty && !edge) {
      return SpawnPlan.none;
    }
    return SpawnPlan(ducks: ducks, edgeDuck: edge);
  }

  double nextEdgeInterval() {
    final e = config.edge;
    return e.minIntervalS + random.nextDouble() * (e.maxIntervalS - e.minIntervalS);
  }

  DuckKind pickKind(PhaseSpec phase) {
    final total = phase.weights.values.fold<double>(0, (a, b) => a + b);
    var roll = random.nextDouble() * total;
    for (final entry in phase.weights.entries) {
      roll -= entry.value;
      if (roll < 0) {
        return entry.key;
      }
    }
    return phase.weights.keys.last;
  }

  /// Random speed for [kind] within its range, scaled by the phase.
  double speedFor(DuckKind kind, double elapsed) {
    final spec = config.ducks[kind]!;
    final base = spec.minSpeed + random.nextDouble() * (spec.maxSpeed - spec.minSpeed);
    return base * config.phaseAt(elapsed).speedScale;
  }
}
