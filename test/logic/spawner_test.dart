import 'dart:math' as math;

import 'package:kaceny/config/game_config.dart';
import 'package:kaceny/game/logic/spawner.dart';
import 'package:test/test.dart';

/// Steps a whole round at 60 fps with nothing ever leaving the screen
/// unless [neverFull] keeps the count at zero.
Map<int, List<DuckKind>> runRound(GameConfig config, {required bool neverFull, int seed = 1}) {
  final spawner = Spawner(config: config, random: math.Random(seed));
  final perPhase = <int, List<DuckKind>>{0: [], 1: [], 2: []};
  const dt = 1 / 60;
  var elapsed = 0.0;
  var alive = 0;
  for (var frame = 0; frame < config.roundSeconds * 60; frame++) {
    elapsed += dt;
    final plan = spawner.update(dt, elapsed: elapsed, flying: neverFull ? 0 : alive, edgeActive: false);
    final phase = config.phases.lastIndexWhere((p) => elapsed >= p.startS);
    perPhase[phase]!.addAll(plan.ducks);
    alive += plan.ducks.length;
  }
  return perPhase;
}

void main() {
  const config = GameConfig.defaults;

  test('phase lookup follows the curve', () {
    expect(config.phaseAt(0).startS, 0);
    expect(config.phaseAt(29.9).startS, 0);
    expect(config.phaseAt(30).startS, 30);
    expect(config.phaseAt(75).startS, 60);
    expect(config.phaseAt(500).startS, 60);
  });

  test('spawn counts per phase match the interval curve', () {
    final counts = runRound(config, neverFull: true);
    // 30 s / interval, ±1 for the frame boundaries and the instant first duck.
    expect(counts[0]!.length, closeTo(30 / 1.1 + 1, 1.5));
    expect(counts[1]!.length, closeTo(30 / 0.8, 1.5));
    expect(counts[2]!.length, closeTo(30 / 0.55, 1.5));
    expect(counts[2]!.length, greaterThan(counts[1]!.length));
    expect(counts[1]!.length, greaterThan(counts[0]!.length));
  });

  test('later phases have a larger share of small ducks', () {
    double smallShare(List<DuckKind> ducks) =>
        ducks.where((k) => k == DuckKind.tiny || k == DuckKind.small).length / ducks.length;
    // Several seeds so the comparison is about the weights, not luck.
    final early = <DuckKind>[];
    final late = <DuckKind>[];
    for (var seed = 0; seed < 20; seed++) {
      final counts = runRound(config, neverFull: true, seed: seed);
      early.addAll(counts[0]!);
      late.addAll(counts[2]!);
    }
    expect(smallShare(early), closeTo(0.3, 0.05));
    expect(smallShare(late), closeTo(0.7, 0.05));
  });

  test('never more than maxOnScreen flying at once', () {
    final spawner = Spawner(config: config, random: math.Random(3));
    var alive = 0;
    for (var i = 0; i < 600; i++) {
      final plan = spawner.update(1 / 60, elapsed: 70, flying: alive, edgeActive: false);
      alive += plan.ducks.length;
      expect(alive, lessThanOrEqualTo(config.maxOnScreen));
    }
    expect(alive, config.maxOnScreen);
  });

  test('a freed slot is filled immediately', () {
    final spawner = Spawner(config: config, random: math.Random(3));
    spawner.update(5, elapsed: 70, flying: config.maxOnScreen, edgeActive: false);
    final plan = spawner.update(1 / 60, elapsed: 70, flying: config.maxOnScreen - 1, edgeActive: false);
    expect(plan.ducks, hasLength(1));
  });

  test('edge duck: first after the delay, then every 8–12 s, never while one is out', () {
    final spawner = Spawner(config: config, random: math.Random(5));
    const dt = 1 / 60;
    final times = <double>[];
    var t = 0.0;
    var edgeUntil = -1.0;
    while (t < 90) {
      t += dt;
      final active = t < edgeUntil;
      final plan = spawner.update(dt, elapsed: t, flying: 0, edgeActive: active);
      if (plan.edgeDuck) {
        expect(active, isFalse);
        times.add(t);
        edgeUntil = t + 2; // stays out for 2 s
      }
    }
    expect(times.first, closeTo(config.edge.firstDelayS, 0.05));
    for (var i = 1; i < times.length; i++) {
      final gap = times[i] - times[i - 1] - 2;
      expect(gap, inInclusiveRange(8 - 0.05, 12 + 0.05));
    }
  });
}
