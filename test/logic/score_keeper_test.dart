import 'package:kaceny/config/game_config.dart';
import 'package:kaceny/game/logic/magazine.dart';
import 'package:kaceny/game/logic/reload_swipe.dart';
import 'package:kaceny/game/logic/score_keeper.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  group('ScoreKeeper', () {
    test('plain and precise hits', () {
      final s = ScoreKeeper(const GameConfig(comboEnabled: false));
      expect(s.hit(points: 10, precise: false), 10);
      expect(s.hit(points: 10, precise: true), 12);
      expect(s.score, 22);
    });

    test('combo: ×1.5 from the 3rd hit, ×2 from the 6th', () {
      final s = ScoreKeeper(GameConfig.defaults);
      final gained = [for (var i = 0; i < 7; i++) s.hit(points: 10, precise: false)];
      expect(gained, [10, 10, 15, 15, 15, 20, 20]);
      expect(s.multiplier, 2);
    });

    test('a miss resets the combo', () {
      final s = ScoreKeeper(GameConfig.defaults);
      for (var i = 0; i < 4; i++) {
        s.hit(points: 1, precise: false);
      }
      s.miss();
      expect(s.multiplier, 1);
      expect(s.hit(points: 10, precise: false), 10);
      expect(s.bestStreak, 4);
    });

    test('combo applies to the precision bonus too and rounds', () {
      final s = ScoreKeeper(GameConfig.defaults);
      s.hit(points: 1, precise: false);
      s.hit(points: 1, precise: false);
      expect(s.hit(points: 1, precise: true), 5); // (1 + 2) × 1.5 = 4.5
    });

    test('accuracy', () {
      final s = ScoreKeeper(GameConfig.defaults);
      expect(s.accuracy, 0);
      s
        ..hit(points: 1, precise: false)
        ..miss()
        ..miss()
        ..hit(points: 1, precise: false);
      expect(s.accuracy, 0.5);
    });
  });

  group('Magazine', () {
    test('8 shots, then dry clicks until reloaded', () {
      final m = Magazine(size: 8, reloadS: 0.4);
      for (var i = 0; i < 8; i++) {
        expect(m.fire(), isTrue);
      }
      expect(m.fire(), isFalse);
      expect(m.startReload(), isTrue);
      expect(m.fire(), isFalse);
      expect(m.update(0.3), isFalse);
      expect(m.reloadProgress, closeTo(0.75, 1e-9));
      expect(m.update(0.11), isTrue);
      expect(m.rounds, 8);
      expect(m.fire(), isTrue);
    });

    test('no reload when full or already reloading', () {
      final m = Magazine(size: 8, reloadS: 0.4);
      expect(m.startReload(), isFalse);
      m.fire();
      expect(m.startReload(), isTrue);
      expect(m.startReload(), isFalse);
    });
  });

  group('ReloadSwipeDetector', () {
    final d = ReloadSwipeDetector(minDistance: 40, maxAngleRad: 30 * 3.141592653589793 / 180);

    test('straight down and up to 30° count', () {
      expect(d.isReloadSwipe(Vector2(0, 41)), isTrue);
      expect(d.isReloadSwipe(Vector2(25, 45)), isTrue); // ~29°
    });

    test('too short, too steep or upwards do not', () {
      expect(d.isReloadSwipe(Vector2(0, 39)), isFalse);
      expect(d.isReloadSwipe(Vector2(30, 45)), isFalse); // ~34°
      expect(d.isReloadSwipe(Vector2(0, -60)), isFalse);
    });

    test('fires once per pointer, mid-gesture', () {
      d.down(1, Vector2(100, 100));
      expect(d.move(1, Vector2(100, 120)), isFalse);
      expect(d.move(1, Vector2(102, 150)), isTrue);
      expect(d.move(1, Vector2(102, 200)), isFalse);
      d.up(1);
      expect(d.move(1, Vector2(102, 300)), isFalse);
    });
  });
}
