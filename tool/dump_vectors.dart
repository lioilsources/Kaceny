// Golden vectors and generated data for the Babylon.js web client (babylon/, plan 06).
//
// Runs the pure Dart rules (lib/config, lib/game/logic)
// over fixed inputs and writes:
//   babylon/src/rules/generated/game-config.json   every GameConfig default (the TS port imports it)
//   babylon/test/golden/<name>.json                {"cases": [{"in": …, "out": …}]}, replayed by Vitest
//
//   dart run tool/dump_vectors.dart     (from the repo root, after flutter pub get)
//
// Deterministic: no clock, no Random() without a seed. Rerunning on unchanged Dart
// code must give byte-identical files (CI diffs them).
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:kaceny/config/game_config.dart';
import 'package:kaceny/game/logic/flight_path.dart';
import 'package:kaceny/game/logic/magazine.dart';
import 'package:kaceny/game/logic/position_history.dart';
import 'package:kaceny/game/logic/reload_swipe.dart';
import 'package:kaceny/game/logic/score_keeper.dart';
import 'package:kaceny/game/logic/spawner.dart';
import 'package:vector_math/vector_math.dart';

const goldenDir = 'babylon/test/golden';
const generatedDir = 'babylon/src/rules/generated';

/// Seeded LCG, mirrored bit for bit by babylon/src/rules/random.ts. Only picks inputs.
class Lcg {
  int _s;
  Lcg(int seed) : _s = seed & 0x7fffffff;
  int next(int n) {
    _s = (_s * 1103515245 + 12345) & 0x7fffffff;
    return _s % n;
  }

  double unit() => next(1 << 30) / (1 << 30);
}

/// A math.Random over [Lcg], mirrored by gameRandom(seed) in babylon/src/rules/random.ts.
/// Lets the rules that take a Random (Spawner, FlightPath.random) be replayed draw for draw.
class LcgRandom implements math.Random {
  LcgRandom(int seed) : _lcg = Lcg(seed);
  final Lcg _lcg;
  @override
  int nextInt(int max) => _lcg.next(max);
  @override
  double nextDouble() => _lcg.unit();
  @override
  bool nextBool() => _lcg.next(2) == 0;
}

void writeJson(String path, Object json) {
  final f = File(path);
  f.parent.createSync(recursive: true);
  f.writeAsStringSync('${const JsonEncoder.withIndent(' ').convert(json)}\n');
  stdout.writeln('wrote ${f.path} (${f.lengthSync()} B)');
}

void writeCases(String name, List<Map<String, Object?>> cases) => writeJson('$goldenDir/$name', {'cases': cases});

// ── Generated data ───────────────────────────────────────────────────────

Map<String, Object?> configJson(GameConfig c) => {
  'roundSeconds': c.roundSeconds,
  'countdownSeconds': c.countdownSeconds,
  'shotCooldownMs': c.shotCooldownMs,
  'hitboxScale': c.hitboxScale,
  'minHitRadiusPt': c.minHitRadiusPt,
  'inputLatencyMs': c.inputLatencyMs,
  'historySize': c.historySize,
  'magazineSize': c.magazineSize,
  'reloadMs': c.reloadMs,
  'reloadSwipeMinPt': c.reloadSwipeMinPt,
  'reloadSwipeMaxAngleDeg': c.reloadSwipeMaxAngleDeg,
  'bottomSafeZonePt': c.bottomSafeZonePt,
  'topHudPt': c.topHudPt,
  'maxOnScreen': c.maxOnScreen,
  'precisionBonus': c.precisionBonus,
  'comboEnabled': c.comboEnabled,
  'comboTiers': [
    for (final t in c.comboTiers) {'hits': t.hits, 'multiplier': t.multiplier},
  ],
  'fallDurationS': c.fallDurationS,
  'fallGravity': c.fallGravity,
  'escapeFadeS': c.escapeFadeS,
  // Map order matters: Spawner.pickKind walks the weights in insertion order.
  'ducks': {
    for (final e in c.ducks.entries)
      e.key.name: {
        'heightPt': e.value.heightPt,
        'minSpeed': e.value.minSpeed,
        'maxSpeed': e.value.maxSpeed,
        'points': e.value.points,
        'paths': [for (final p in e.value.paths) p.name],
      },
  },
  'phases': [
    for (final p in c.phases)
      {
        'startS': p.startS,
        'spawnIntervalS': p.spawnIntervalS,
        'weights': [
          for (final w in p.weights.entries) [w.key.name, w.value],
        ],
        'speedScale': p.speedScale,
      },
  ],
  'edge': {
    'heightPt': c.edge.heightPt,
    'points': c.edge.points,
    'minShowS': c.edge.minShowS,
    'maxShowS': c.edge.maxShowS,
    'slideS': c.edge.slideS,
    'minIntervalS': c.edge.minIntervalS,
    'maxIntervalS': c.edge.maxIntervalS,
    'firstDelayS': c.edge.firstDelayS,
    'revealFraction': c.edge.revealFraction,
  },
};

// ── Vectors ──────────────────────────────────────────────────────────────

/// Flight paths with explicit shapes (no Random): positions over 3 s.
List<Map<String, Object?>> flightCases() {
  final r = Lcg(7);
  final out = <Map<String, Object?>>[];
  for (final kind in FlightPathKind.values) {
    for (var i = 0; i < 6; i++) {
      final minX = 10 + r.next(40).toDouble();
      final maxX = minX + 40 + r.next(380);
      final p = FlightPath(
        kind: kind,
        startX: minX + r.unit() * (maxX - minX),
        startY: -r.next(80).toDouble(),
        speed: 100 + r.next(350).toDouble(),
        minX: minX,
        maxX: maxX,
        angle: (r.unit() - 0.5) * 1.2,
        amplitude: r.next(60).toDouble(),
        frequency: 0.5 + r.unit(),
        phase: r.unit() * 6.28,
      );
      out.add({
        'in': {
          'kind': kind.name,
          'startX': p.startX,
          'startY': p.startY,
          'speed': p.speed,
          'minX': p.minX,
          'maxX': p.maxX,
          'angle': p.angle,
          'amplitude': p.amplitude,
          'frequency': p.frequency,
          'phase': p.phase,
        },
        'out': [
          for (var k = 0; k <= 30; k++) [p.positionAt(k * 0.1).x, p.positionAt(k * 0.1).y],
        ],
      });
    }
  }
  return out;
}

/// Shot sequences: true = hit (with points and precise), false = miss.
List<Map<String, Object?>> scoreCases() {
  final r = Lcg(11);
  final out = <Map<String, Object?>>[];
  for (var i = 0; i < 20; i++) {
    final s = ScoreKeeper(GameConfig.defaults);
    final shots = <Map<String, Object?>>[];
    final gained = <int>[];
    for (var k = 0; k < 4 + r.next(20); k++) {
      if (r.next(4) == 0) {
        shots.add({'hit': false});
        s.miss();
        gained.add(0);
      } else {
        final points = const [1, 3, 5, 10, 5][r.next(5)];
        final precise = r.next(3) == 0;
        shots.add({'hit': true, 'points': points, 'precise': precise});
        gained.add(s.hit(points: points, precise: precise));
      }
    }
    out.add({
      'in': shots,
      'out': {'gained': gained, 'score': s.score, 'shots': s.shots, 'hits': s.hits, 'bestStreak': s.bestStreak},
    });
  }
  return out;
}

/// Magazine: a timeline of fire / reload / tick(dt) and the state after each.
List<Map<String, Object?>> magazineCases() {
  final r = Lcg(13);
  final out = <Map<String, Object?>>[];
  for (var i = 0; i < 10; i++) {
    final m = Magazine(size: GameConfig.defaults.magazineSize, reloadS: GameConfig.defaults.reloadS);
    final ops = <Object>[];
    final states = <Object>[];
    for (var k = 0; k < 40; k++) {
      final o = r.next(3);
      Object res;
      if (o == 0) {
        ops.add('fire');
        res = m.fire();
      } else if (o == 1) {
        ops.add('reload');
        res = m.startReload();
      } else {
        final dt = (1 + r.next(16)) / 120;
        ops.add(dt);
        res = m.update(dt);
      }
      states.add([res, m.rounds, m.reloading]);
    }
    out.add({'in': ops, 'out': states});
  }
  return out;
}

/// Position history: samples, then queries at times around them.
List<Map<String, Object?>> historyCases() {
  final r = Lcg(17);
  final out = <Map<String, Object?>>[];
  for (var i = 0; i < 10; i++) {
    final h = PositionHistory(GameConfig.defaults.historySize);
    final samples = <List<double>>[];
    var t = 0.0;
    for (var k = 0; k < 5 + r.next(15); k++) {
      t += r.next(3) == 0 ? 0 : (1 + r.next(4)) / 60;
      final s = [t, r.next(400).toDouble(), r.next(800).toDouble()];
      samples.add(s);
      h.record(s[0], s[1], s[2]);
    }
    final queries = [for (var k = 0; k < 12; k++) -0.05 + r.unit() * (t + 0.1)];
    out.add({
      'in': {'capacity': h.capacity, 'samples': samples, 'queries': queries},
      'out': [
        for (final q in queries) [h.sample(q).x, h.sample(q).y],
      ],
    });
  }
  return out;
}

/// Reload swipe: deltas and whether they count.
List<Map<String, Object?>> swipeCases() {
  final c = GameConfig.defaults;
  final d = ReloadSwipeDetector(minDistance: c.reloadSwipeMinPt, maxAngleRad: c.reloadSwipeMaxAngleRad);
  final r = Lcg(19);
  return [
    for (var i = 0; i < 60; i++)
      () {
        final dx = (r.next(161) - 80).toDouble();
        final dy = (r.next(161) - 40).toDouble();
        return {
          'in': [dx, dy],
          'out': d.isReloadSwipe(Vector2(dx, dy)),
        };
      }(),
  ];
}

/// FlightPath.random from a seeded Random: kind, shape and positions over 2 s.
List<Map<String, Object?>> flightRandomCases() {
  final r = Lcg(23);
  final kinds = FlightPathKind.values;
  return [
    for (var i = 0; i < 24; i++)
      () {
        final seed = 1 + r.next(1 << 30);
        final allowed = [
          for (final k in kinds)
            if (r.next(2) == 0 || k == kinds[i % kinds.length]) k,
        ];
        final minX = 10 + r.next(40).toDouble();
        final maxX = minX + 20 + r.next(380);
        final startY = -r.next(80).toDouble();
        final speed = 100 + r.next(350).toDouble();
        final p = FlightPath.random(
          random: LcgRandom(seed),
          allowed: allowed,
          startY: startY,
          speed: speed,
          minX: minX,
          maxX: maxX,
        );
        return {
          'in': {
            'seed': seed,
            'allowed': [for (final k in allowed) k.name],
            'startY': startY,
            'speed': speed,
            'minX': minX,
            'maxX': maxX,
          },
          'out': {
            'kind': p.kind.name,
            'positions': [
              for (var k = 0; k <= 20; k++) [p.positionAt(k * 0.1).x, p.positionAt(k * 0.1).y],
            ],
          },
        };
      }(),
  ];
}

/// Spawner over a whole round: for each step that spawns, its index, the ducks it asks for (each with the speed the game
/// would draw next), whether an edge duck comes, in the same Random order as KacenyGame.
List<Map<String, Object?>> spawnerCases() {
  final c = GameConfig.defaults;
  final r = Lcg(29);
  final out = <Map<String, Object?>>[];
  for (var i = 0; i < 3; i++) {
    final seed = 1 + r.next(1 << 30);
    final s = Spawner(config: c, random: LcgRandom(seed));
    final steps = <List<Object>>[];
    final plans = <List<Object>>[];
    var elapsed = 0.0;
    var flying = 0;
    var edgeActive = false;
    while (elapsed < c.roundSeconds) {
      final dt = (1 + r.next(24)) / 120;
      elapsed += dt;
      final plan = s.update(dt, elapsed: elapsed, flying: flying, edgeActive: edgeActive);
      steps.add([dt, elapsed, flying, edgeActive]);
      if (plan.ducks.isNotEmpty || plan.edgeDuck) {
        plans.add([
          steps.length - 1,
          [
            for (final k in plan.ducks) [k.name, s.speedFor(k, elapsed)],
          ],
          plan.edgeDuck,
        ]);
      }
      // Fake world: ducks leave at random, the edge duck stays a while.
      flying = math.max(0, flying + plan.ducks.length - r.next(2));
      if (plan.edgeDuck) edgeActive = true;
      if (edgeActive && r.next(60) == 0) edgeActive = false;
    }
    out.add({
      'in': {'seed': seed, 'steps': steps},
      'out': plans,
    });
  }
  return out;
}

void main() {
  writeJson('$generatedDir/game-config.json', configJson(GameConfig.defaults));
  writeCases('flight-path.json', flightCases());
  writeCases('flight-random.json', flightRandomCases());
  writeCases('history.json', historyCases());
  writeCases('magazine.json', magazineCases());
  writeCases('score.json', scoreCases());
  writeCases('spawner.json', spawnerCases());
  writeCases('swipe.json', swipeCases());
}
