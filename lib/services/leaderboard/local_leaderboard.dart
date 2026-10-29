import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'leaderboard_repository.dart';

/// Top 20 on the device, a JSON list in shared_preferences (§6).
class LocalLeaderboard implements LeaderboardRepository {
  LocalLeaderboard({this._prefs});

  static const capacity = 20;
  static const _key = 'leaderboard.local.v1';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _store async => _prefs ??= await SharedPreferences.getInstance();

  @override
  Future<List<LeaderboardEntry>> top() async {
    final raw = (await _store).getString(_key);
    if (raw == null) {
      return [];
    }
    try {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>().map(LeaderboardEntry.fromJson).toList();
      _sort(list);
      return list.take(capacity).toList();
    } catch (error) {
      debugPrint('Kačeny: local leaderboard unreadable, starting over: $error');
      return [];
    }
  }

  @override
  Future<bool> qualifies(int score) async {
    if (score <= 0) {
      return false;
    }
    final entries = await top();
    return entries.length < capacity || score > entries.last.score;
  }

  @override
  Future<int?> add(LeaderboardEntry entry) async {
    if (entry.score <= 0) {
      return null;
    }
    final entries = await top()
      ..add(entry);
    _sort(entries);
    final kept = entries.take(capacity).toList();
    final rank = kept.indexOf(entry);
    await (await _store).setString(_key, jsonEncode([for (final e in kept) e.toJson()]));
    return rank < 0 ? null : rank;
  }

  /// Higher score first; on a tie the older entry keeps its place.
  static void _sort(List<LeaderboardEntry> list) {
    list.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      return byScore != 0 ? byScore : a.date.compareTo(b.date);
    });
  }
}
