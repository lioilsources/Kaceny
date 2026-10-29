import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:games_services/games_services.dart';

/// The optional online board: Game Center on iOS, Play Games on Android (§6).
///
/// Everything is best-effort. The player may decline sign-in, the Android
/// build may ship before the Play Console board exists, a submit can fail
/// offline — none of it may disturb a round, so failures are swallowed and
/// [available] simply stays false.
class GamesServicesLeaderboard extends ChangeNotifier {
  /// "All time" board ID in App Store Connect. Placeholder until created.
  static const iosLeaderboardId = 'kaceny.alltime';

  /// "All time" board ID from Play Console (looks like `CgkI…EAIQAQ`).
  /// While empty, the Android build behaves as if there were no online board.
  static const androidLeaderboardId = '';

  bool _available = false;
  StreamSubscription<PlayerData?>? _player;

  /// Signed in; scores can be submitted and the board shown.
  bool get available => _available;

  static bool get _android => defaultTargetPlatform == TargetPlatform.android && androidLeaderboardId.isNotEmpty;

  static bool get supported => !kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || _android);

  /// Whether the menu shows the online entry point at all. On Android the
  /// button is the sign-in; on iOS Game Center signs in at launch or from
  /// Settings.
  bool get offered => _available || _android;

  /// Silent sign-in at startup. The player stream, not the call's result,
  /// decides [available]: authentication may finish much later.
  Future<void> signIn() async {
    if (!supported) {
      return;
    }
    _player ??= GameAuth.player.listen(
      (player) => _setAvailable(player != null),
      onError: (Object error) {
        debugPrint('Kačeny: games services player stream failed: $error');
        _setAvailable(false);
      },
    );
    if (_android) {
      // Play Games tries its own sign-in at launch; calling signIn here would
      // pop a dialog on every start for a player who declined once.
      return;
    }
    await _prompt();
  }

  Future<void> _prompt() async {
    try {
      await GameAuth.signIn();
    } catch (error) {
      debugPrint('Kačeny: games services sign-in failed: $error');
    }
  }

  void _setAvailable(bool value) {
    if (value != _available) {
      _available = value;
      notifyListeners();
    }
  }

  Future<void> submit(int score) async {
    if (!_available || score <= 0) {
      return;
    }
    try {
      await Leaderboards.submitScore(
        score: Score(iOSLeaderboardID: iosLeaderboardId, androidLeaderboardID: androidLeaderboardId, value: score),
      );
    } catch (error) {
      debugPrint('Kačeny: score submit failed: $error');
    }
  }

  /// Opens the system leaderboard UI, signing in first on Android.
  Future<void> show() async {
    if (!_available && _android) {
      await _prompt();
      _setAvailable(await GameAuth.isSignedIn);
    }
    if (!_available) {
      return;
    }
    try {
      await Leaderboards.showLeaderboards(
        iOSLeaderboardID: iosLeaderboardId,
        androidLeaderboardID: androidLeaderboardId,
      );
    } catch (error) {
      debugPrint('Kačeny: leaderboard failed to open: $error');
    }
  }

  @override
  void dispose() {
    _player?.cancel();
    super.dispose();
  }
}
