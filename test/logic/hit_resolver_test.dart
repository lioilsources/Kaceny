import 'package:kaceny/config/game_config.dart';
import 'package:kaceny/game/logic/hit_resolver.dart';
import 'package:kaceny/game/logic/position_history.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

class FakeTarget implements HitTarget {
  FakeTarget(this.name, {required this.spriteRadius, this.hittable = true});

  final String name;
  @override
  final double spriteRadius;
  @override
  bool hittable;
  final history = PositionHistory(8);

  /// Stands still at (x, y) from time 0.
  FakeTarget at(double x, double y) {
    history.record(0, x, y);
    return this;
  }

  @override
  Vector2 positionAt(double time) => history.sample(time);

  @override
  String toString() => name;
}

void main() {
  // Lag compensation off unless a test turns it on.
  const config = GameConfig(inputLatencyMs: 0);
  late List<FakeTarget> targets;
  late HitResolver<FakeTarget> resolver;

  setUp(() {
    targets = [];
    resolver = HitResolver(config: config, targets: () => targets);
  });

  test('no targets → null', () {
    expect(resolver.resolve(Vector2(10, 10), 1), isNull);
  });

  test('shot outside every hit circle → null', () {
    targets.add(FakeTarget('a', spriteRadius: 20).at(100, 100));
    // hitRadius = 26
    expect(resolver.resolve(Vector2(100, 127), 1), isNull);
  });

  test('inside the sprite is a precise hit', () {
    targets.add(FakeTarget('a', spriteRadius: 20).at(100, 100));
    final r = resolver.resolve(Vector2(110, 100), 1)!;
    expect(r.target.name, 'a');
    expect(r.precise, isTrue);
    expect(r.distance, closeTo(10, 1e-9));
  });

  test('in the ring between sprite and hit radius is a plain hit', () {
    targets.add(FakeTarget('a', spriteRadius: 20).at(100, 100));
    final r = resolver.resolve(Vector2(100, 124), 1)!;
    expect(r.precise, isFalse);
  });

  test('tiny sprites get the 22 pt minimum hit radius', () {
    targets.add(FakeTarget('tiny', spriteRadius: 12).at(100, 100));
    expect(resolver.resolve(Vector2(121, 100), 1)?.precise, isFalse);
    expect(resolver.resolve(Vector2(123, 100), 1), isNull);
  });

  test('overlapping circles: the nearest centre wins', () {
    targets
      ..add(FakeTarget('big', spriteRadius: 40).at(100, 100))
      ..add(FakeTarget('small', spriteRadius: 18).at(130, 100));
    expect(resolver.resolve(Vector2(120, 100), 1)!.target.name, 'small');
    expect(resolver.resolve(Vector2(112, 100), 1)!.target.name, 'big');
  });

  test('equal distance: the bigger (foreground) target wins, order-independent', () {
    targets
      ..add(FakeTarget('small', spriteRadius: 18).at(80, 100))
      ..add(FakeTarget('big', spriteRadius: 40).at(120, 100));
    expect(resolver.resolve(Vector2(100, 100), 1)!.target.name, 'big');
    targets = targets.reversed.toList();
    expect(resolver.resolve(Vector2(100, 100), 1)!.target.name, 'big');
  });

  test('targets that are not hittable are ignored', () {
    targets
      ..add(FakeTarget('falling', spriteRadius: 30, hittable: false).at(100, 100))
      ..add(FakeTarget('other', spriteRadius: 30).at(140, 100));
    expect(resolver.resolve(Vector2(100, 100), 1), isNull);
    expect(resolver.resolve(Vector2(125, 100), 1)!.target.name, 'other');
  });

  group('lag compensation', () {
    setUp(() {
      resolver = HitResolver(config: const GameConfig(inputLatencyMs: 60), targets: () => targets);
    });

    // Falls at 300 pt/s, sampled every 1/60 s.
    FakeTarget falling() {
      final t = FakeTarget('duck', spriteRadius: 18);
      for (var i = 0; i <= 12; i++) {
        final time = i / 60;
        t.history.record(time, 100, 300 * time);
      }
      return t;
    }

    test('tests the position 60 ms before the shot', () {
      targets.add(falling());
      // Shot at t = 0.2: now the duck is at y = 60, 60 ms ago at y = 42.
      final r = resolver.resolve(Vector2(100, 42), 0.2)!;
      expect(r.precise, isTrue);
      expect(r.distance, closeTo(0, 1e-6));
      expect(r.center.y, closeTo(42, 1e-6));
    });

    test('interpolates between samples', () {
      targets.add(falling());
      // 0.15 - 0.06 = 0.09 s lies between samples 5/60 and 6/60.
      final r = resolver.resolve(Vector2(100, 30), 0.15)!;
      expect(r.center.y, closeTo(27, 1e-6));
    });

    test('a shot at where the duck is now, not where it was, can miss', () {
      targets.add(falling());
      // Fast duck: at t = 0.2 it is 18 pt below the compensated position, the
      // shot 40 pt below is outside the 23.4 pt hit radius.
      expect(resolver.resolve(Vector2(100, 82), 0.2), isNull);
    });

    test('older than the history clamps to the oldest sample', () {
      final t = FakeTarget('new', spriteRadius: 20);
      t.history.record(1.0, 50, 50);
      t.history.record(1.1, 50, 80);
      targets.add(t);
      expect(resolver.resolve(Vector2(50, 50), 1.02)!.center.y, closeTo(50, 1e-9));
    });
  });

  group('PositionHistory', () {
    test('keeps only the last capacity samples', () {
      final h = PositionHistory(3);
      for (var i = 0; i < 5; i++) {
        h.record(i.toDouble(), i * 10.0, 0);
      }
      expect(h.length, 3);
      expect(h.sample(0).x, 20); // clamped to oldest kept (t = 2)
      expect(h.sample(3.5).x, 35);
      expect(h.sample(9).x, 40);
    });

    test('same timestamp replaces the newest sample', () {
      final h = PositionHistory(3)
        ..record(1, 0, 0)
        ..record(1, 5, 5);
      expect(h.length, 1);
      expect(h.sample(1).x, 5);
    });
  });
}
