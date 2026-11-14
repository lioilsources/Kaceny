import 'package:flutter/widgets.dart';
import 'package:ol1n_telemetry/ol1n_telemetry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/kaceny_game.dart';
import '../game/skins/skin.dart';
import '../l10n/app_localizations.dart';
import 'skin_store.dart';

/// The app version this build reports; `test/telemetry_test.dart` keeps it
/// equal to `version:` in `pubspec.yaml`.
const kAppVersion = '1.0.0';

/// Id of the app in StoreMetrics `apps.yaml`.
const kTelemetryApp = 'kaceny';

/// Tester build: `--dart-define=TESTER=true`, or a build that unlocks every
/// pack (the sideloaded APK, store screenshots).
const kTesterBuild = bool.fromEnvironment('TESTER') || SkinStore.testerUnlock;

/// What the player is looking at. The game route reports the round's state.
enum KacenyScreen { menu, play, pause, result, skins, leaderboard, settings }

/// Route names of the pushed screens; the game route is [gameRoute].
const gameRoute = '/game';
const kScreenRoutes = {
  '/': 'menu',
  gameRoute: 'play',
  '/skins': 'skins',
  '/leaderboard': 'leaderboard',
  '/settings': 'settings',
};

/// How a round ended. `death` is the shared name for a run played to the
/// end: for Kačeny, the 90 seconds ran out.
enum RunEnd { death, restart, menu }

/// Where a round was started from.
enum RunFrom { menu, result, pause }

/// The one event dictionary of Kačeny, mirrored in `docs/telemetry.md`.
final kacenyDictionary = TelemetryDictionary(
  appVersion: kAppVersion,
  languages: {for (final l in AppLocalizations.supportedLocales) telemetryLocaleId(l)},
  screens: {for (final s in KacenyScreen.values) s.name},
  features: {
    'skins',
    'leaderboard',
    'online_board',
    'initials',
    'reload_swipe',
    'reload_tap',
    'auto_reload',
    'sound_off',
    'haptics_off',
    'restore',
  },
  errorKinds: {'store_unavailable', 'purchase_failed'},
  lockedTargets: {...SkinStore.paidPacks},
  sessionPause: {'runs': const IntProp(100000)},
  events: {
    'game_ready': {
      'ms': const IntProp(600000),
      'art': const EnumProp({'vector', 'picture', 'animated'}),
    },
    ...TelemetryDictionary.flow(
      'run',
      results: {for (final r in RunEnd.values) r.name},
      start: {
        'from': EnumProp({for (final f in RunFrom.values) f.name}),
        'skin': EnumProp({for (final s in Skin.all) s.id}),
        'auto_reload': const BoolProp(),
      },
      end: {
        'level': const IntProp(20),
        'cause': const EnumProp({'time', 'none'}),
        'score': const IntProp(),
        'shots': const IntProp(100000),
        'hits': const IntProp(100000),
        'streak': const IntProp(100000),
      },
    ),
    'skin_pick': {
      'skin': EnumProp({for (final s in Skin.all) s.id}),
      'free': const BoolProp(),
    },
    ...TelemetryDictionary.flow(
      'purchase',
      results: {'unavailable'},
      start: {
        'pack': EnumProp({...SkinStore.paidPacks, SkinStore.allPacks}),
        'from': const EnumProp({'skin', 'pack', 'bundle'}),
      },
      end: {
        'pack': EnumProp({...SkinStore.paidPacks, SkinStore.allPacks}),
      },
    ),
  },
);

/// [TelemetryStore] over the SharedPreferences the app already keeps.
class PrefsTelemetryStore implements TelemetryStore {
  PrefsTelemetryStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<String?> read(String key) async => _prefs.getString(key);

  @override
  Future<void> write(String key, String value) => _prefs.setString(key, value);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}

/// The language MaterialApp picks: the first device language the game
/// speaks, English otherwise.
Locale resolveAppLocale(List<Locale>? locales, Iterable<Locale> supported) {
  for (final locale in locales ?? const <Locale>[]) {
    for (final s in supported) {
      if (s.languageCode == locale.languageCode) {
        return s;
      }
    }
  }
  return const Locale('en');
}

/// `lang` of every event: the app's language right now.
String telemetryLang() => telemetryLocaleId(
  resolveAppLocale(WidgetsBinding.instance.platformDispatcher.locales, AppLocalizations.supportedLocales),
);

/// Turns rounds and game states into events. Measuring never steers the
/// game: nothing here is read back by it.
class KacenyTelemetry {
  TelemetryFlow? _run;

  /// Rounds started this process (sent with `session_pause`).
  int runs = 0;

  /// The game route's screen as last reported: `play`, `pause` or `result`.
  KacenyScreen gameScreen = KacenyScreen.play;

  /// A round state changed while the app was not in the foreground (the
  /// game pauses itself on the way out); reported on the way back.
  bool _deferred = false;

  /// The round on screen changed phase.
  void phaseChanged(RoundPhase phase) {
    gameScreen = switch (phase) {
      RoundPhase.playing => KacenyScreen.play,
      RoundPhase.paused => KacenyScreen.pause,
      RoundPhase.over => KacenyScreen.result,
    };
    // Leaving the app pauses the round first; reporting it now would make
    // every session that ends mid-round end on `pause`.
    final state = WidgetsBinding.instance.lifecycleState;
    if (state != null && state != AppLifecycleState.resumed) {
      _deferred = true;
      return;
    }
    _deferred = false;
    Telemetry.screen(gameScreen.name);
  }

  /// Back in the foreground on the game route.
  void resumed() {
    if (_deferred) {
      _deferred = false;
      Telemetry.screen(gameScreen.name);
    }
  }

  /// The game route is gone.
  void gameClosed() {
    _deferred = false;
    gameScreen = KacenyScreen.play;
  }

  void gameReady(Duration loading, Skin skin) {
    Telemetry.track('game_ready', {
      'ms': loading.inMilliseconds.clamp(0, 600000),
      'art': skin.isVector ? 'vector' : (skin.animated ? 'animated' : 'picture'),
    });
  }

  void runStarted(KacenyGame game, RunFrom from) {
    runs++;
    _run = Telemetry.flow(
      'run',
      {'from': from.name, 'skin': game.skin.id, 'auto_reload': game.autoReload},
      // A round left in the background ends with these if the app never
      // comes back.
      () => _endProps(game, over: false),
    );
  }

  /// Ends the open round; nothing when none is open.
  void runEnded(KacenyGame game, RunEnd end) {
    final run = _run;
    _run = null;
    if (run == null || run.ended) {
      return;
    }
    run.end(end.name, _endProps(game, over: end == RunEnd.death));
    if (end == RunEnd.death) {
      // The first round played to the end is the first real use.
      Telemetry.activation();
    }
  }

  void reloaded(ReloadTrigger trigger) {
    switch (trigger) {
      case ReloadTrigger.swipe:
        Telemetry.feature('reload_swipe');
      case ReloadTrigger.tap:
        Telemetry.feature('reload_tap');
      case ReloadTrigger.auto:
        break;
    }
  }

  static Map<String, Object> _endProps(KacenyGame game, {required bool over}) {
    final phases = game.config.phases;
    final level = phases.lastIndexWhere((p) => game.elapsed >= p.startS);
    return {
      'level': level.clamp(0, 20),
      'cause': over ? 'time' : 'none',
      'score': game.score.score.clamp(0, 1000000000),
      'shots': game.score.shots.clamp(0, 100000),
      'hits': game.score.hits.clamp(0, 100000),
      'streak': game.score.bestStreak.clamp(0, 100000),
    };
  }
}

/// Screens from route names; the game route asks [telemetry] for the round's
/// state (back from the leaderboard to a finished round is `result`).
class KacenyNavigatorObserver extends TelemetryNavigatorObserver {
  KacenyNavigatorObserver(this.telemetry) : super(kScreenRoutes);

  final KacenyTelemetry telemetry;

  @override
  String screenOf(Route<dynamic> route) =>
      route.settings.name == gameRoute ? telemetry.gameScreen.name : super.screenOf(route);
}
