// The checks every app copies from ol1n_telemetry (README "Testovací sada")
// plus the game's own hooks: screens, rounds and purchases.

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaceny/game/kaceny_game.dart';
import 'package:kaceny/game/skins/skin.dart';
import 'package:kaceny/services/haptics.dart';
import 'package:kaceny/services/sfx.dart';
import 'package:kaceny/services/telemetry.dart';
import 'package:ol1n_telemetry/ol1n_telemetry.dart';
import 'package:ol1n_telemetry/testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('docs/telemetry.md lists exactly the dictionary', () {
    expect(telemetryDocProblems(kacenyDictionary, File('docs/telemetry.md').readAsStringSync()), isEmpty);
  });

  test('no property is free text', () {
    expect(telemetryDictionaryProblems(kacenyDictionary), isEmpty);
  });

  test('app version matches pubspec.yaml', () {
    expect(telemetryVersionProblems(kAppVersion, File('pubspec.yaml').readAsStringSync()), isEmpty);
  });

  test('the code sends only dictionary events, and every one of them', () {
    expect(telemetryTrackCallProblems(kacenyDictionary), isEmpty);
  });

  test('no key, no network', () async {
    expect(await telemetryNoKeyProblems(kacenyDictionary), isEmpty);
  }, skip: const bool.fromEnvironment('TELEMETRY_DEBUG'));

  test('off means nothing', () async {
    expect(await telemetryOffProblems(kacenyDictionary), isEmpty);
  });

  test('route names map to screens; the game route follows the round', () {
    final hooks = KacenyTelemetry();
    final observer = KacenyNavigatorObserver(hooks);
    for (final screen in kScreenRoutes.values) {
      expect(kacenyDictionary.screens, contains(screen));
    }
    expect(observer.screenOfName('/skins'), 'skins');
    expect(observer.screenOfName('/nowhere'), 'other');
    hooks.gameScreen = KacenyScreen.result;
    final route = PageRouteBuilder<void>(
      settings: const RouteSettings(name: gameRoute),
      pageBuilder: (_, _, _) => const SizedBox(),
    );
    expect(observer.screenOf(route), 'result');
  });

  test('the app language resolves like MaterialApp, English otherwise', () {
    const supported = [Locale('cs'), Locale('en'), Locale('de')];
    expect(resolveAppLocale(const [Locale('de', 'AT')], supported), const Locale('de'));
    expect(resolveAppLocale(const [Locale('ja')], supported), const Locale('en'));
  });

  group('game hooks', () {
    late KacenyTelemetry hooks;
    late KacenyGame game;

    setUp(() async {
      Telemetry.resetForTest();
      await Telemetry.init(
        app: kTelemetryApp,
        appVersion: kAppVersion,
        dictionary: kacenyDictionary,
        store: MemoryTelemetryStore(),
        lang: () => 'en',
        pauseProps: () => {'runs': 0},
        sink: FakeSink(),
        startTimer: false,
        observeLifecycle: false,
      );
      hooks = KacenyTelemetry();
      game = KacenyGame(sfx: Sfx(), haptics: Haptics(), skin: Skin.byId('pixel8'));
    });

    tearDown(Telemetry.resetForTest);

    List<String> names() => [for (final e in Telemetry.debugQueue) e.name];
    TelemetryEvent last(String name) => Telemetry.debugQueue.lastWhere((e) => e.name == name);

    test('round phases are game screens', () {
      Telemetry.screen('menu');
      hooks.phaseChanged(RoundPhase.paused);
      expect(Telemetry.debugScreen, 'pause');
      hooks.phaseChanged(RoundPhase.over);
      expect(Telemetry.debugScreen, 'result');
      expect(last('screen_leave').props['screen'], 'pause');
    });

    test('a round played to the end activates once', () {
      hooks.runStarted(game, RunFrom.menu);
      game
        ..elapsed = 75
        ..score.hit(points: 120, precise: false)
        ..score.miss();
      hooks.runEnded(game, RunEnd.death);
      hooks.runStarted(game, RunFrom.result);
      hooks.runEnded(game, RunEnd.death);

      expect(names().where((n) => n == 'activation'), hasLength(1));
      final start = Telemetry.debugQueue.firstWhere((e) => e.name == 'run_start');
      expect(start.props, containsPair('from', 'menu'));
      expect(start.props, containsPair('skin', 'pixel8'));
      expect(start.props, containsPair('auto_reload', false));
      expect(last('run_start').props['from'], 'result');
      final end = Telemetry.debugQueue.firstWhere((e) => e.name == 'run_end');
      expect(end.props, containsPair('result', 'death'));
      expect(end.props, containsPair('cause', 'time'));
      expect(end.props, containsPair('level', 2));
      expect(end.props, containsPair('score', 120));
      expect(end.props, containsPair('shots', 2));
      expect(end.props, containsPair('hits', 1));
      expect(hooks.runs, 2);
    });

    test('leaving a round is not an activation', () {
      hooks.runStarted(game, RunFrom.menu);
      hooks.runEnded(game, RunEnd.restart);
      hooks.runStarted(game, RunFrom.pause);
      hooks.runEnded(game, RunEnd.menu);
      // The screen closing after Menu ends nothing more.
      hooks.runEnded(game, RunEnd.menu);

      expect(names(), isNot(contains('activation')));
      expect(names().where((n) => n == 'run_end'), hasLength(2));
      expect(last('run_end').props, containsPair('result', 'menu'));
      expect(last('run_end').props, containsPair('cause', 'none'));
      expect(last('run_end').props, containsPair('level', 0));
    });

    test('reloads by swipe and tap are features, the automatic one is not', () {
      hooks.reloaded(ReloadTrigger.auto);
      expect(names(), isNot(contains('feature_use')));
      hooks.reloaded(ReloadTrigger.swipe);
      hooks.reloaded(ReloadTrigger.tap);
      expect(
        [for (final e in Telemetry.debugQueue.where((e) => e.name == 'feature_use')) e.props['feature']],
        ['reload_swipe', 'reload_tap'],
      );
    });

    test('game load time names the kind of art', () {
      hooks.gameReady(const Duration(milliseconds: 420), Skin.byId('pixel8'));
      expect(last('game_ready').props, containsPair('ms', 420));
      expect(last('game_ready').props, containsPair('art', 'animated'));
      hooks.gameReady(const Duration(milliseconds: 80), Skin.vector);
      expect(last('game_ready').props, containsPair('art', 'vector'));
    });
  });
}
