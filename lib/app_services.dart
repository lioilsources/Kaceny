import 'services/haptics.dart';
import 'services/leaderboard/games_services_leaderboard.dart';
import 'services/leaderboard/leaderboard_repository.dart';
import 'services/settings.dart';
import 'services/sfx.dart';

/// The app-wide services, created once in main and handed down.
class AppServices {
  AppServices({
    required this.settings,
    required this.sfx,
    required this.haptics,
    required this.leaderboard,
    required this.online,
  }) {
    settings.addListener(_apply);
    _apply();
  }

  final Settings settings;
  final Sfx sfx;
  final Haptics haptics;
  final LeaderboardRepository leaderboard;
  final GamesServicesLeaderboard online;

  void _apply() {
    sfx.enabled = settings.sound;
    haptics.enabled = settings.haptics;
  }
}
