import 'package:flutter_test/flutter_test.dart';
import 'package:kaceny/services/leaderboard/leaderboard_repository.dart';
import 'package:kaceny/services/leaderboard/local_leaderboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalLeaderboard board;
  final day = DateTime(2026, 10, 29);

  LeaderboardEntry entry(int score, {String initials = 'AAA', int minute = 0}) => LeaderboardEntry(
    initials: initials,
    score: score,
    date: day.add(Duration(minutes: minute)),
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    board = LocalLeaderboard(prefs: await SharedPreferences.getInstance());
  });

  test('starts empty; any positive score qualifies', () async {
    expect(await board.top(), isEmpty);
    expect(await board.qualifies(1), isTrue);
    expect(await board.qualifies(0), isFalse);
  });

  test('sorted best first, returns the rank', () async {
    expect(await board.add(entry(50)), 0);
    expect(await board.add(entry(80)), 0);
    expect(await board.add(entry(60)), 1);
    expect((await board.top()).map((e) => e.score), [80, 60, 50]);
  });

  test('tie: the older entry stays ahead', () async {
    await board.add(entry(50, initials: 'OLD', minute: 0));
    expect(await board.add(entry(50, initials: 'NEW', minute: 5)), 1);
    expect((await board.top()).first.initials, 'OLD');
  });

  test('keeps only the top 20', () async {
    for (var i = 1; i <= 25; i++) {
      await board.add(entry(i * 10, minute: i));
    }
    final top = await board.top();
    expect(top, hasLength(LocalLeaderboard.capacity));
    expect(top.first.score, 250);
    expect(top.last.score, 60);
    expect(await board.qualifies(60), isFalse);
    expect(await board.qualifies(61), isTrue);
    expect(await board.add(entry(5)), isNull);
  });

  test('survives a reload from storage, round-tripping all fields', () async {
    await board.add(LeaderboardEntry(initials: 'ŽÁK', score: 42, date: day, accuracy: 0.75));
    final again = LocalLeaderboard(prefs: await SharedPreferences.getInstance());
    final e = (await again.top()).single;
    expect(e.initials, 'ŽÁK');
    expect(e.score, 42);
    expect(e.date, day);
    expect(e.accuracy, 0.75);
  });

  test('corrupt storage reads as empty', () async {
    SharedPreferences.setMockInitialValues({'leaderboard.local.v1': 'not json'});
    final broken = LocalLeaderboard(prefs: await SharedPreferences.getInstance());
    expect(await broken.top(), isEmpty);
  });
}
