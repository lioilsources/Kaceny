import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_services.dart';
import 'services/haptics.dart';
import 'services/leaderboard/games_services_leaderboard.dart';
import 'services/leaderboard/local_leaderboard.dart';
import 'services/settings.dart';
import 'services/sfx.dart';
import 'ui/game_screen.dart';
import 'ui/menu_screen.dart';
import 'ui/skins_screen.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await _configureAudioSession();
  final services = AppServices(
    settings: await Settings.load(),
    sfx: Sfx(),
    haptics: Haptics(),
    leaderboard: LocalLeaderboard(),
    online: GamesServicesLeaderboard(),
  );
  // Neither may hold up the first frame.
  services.sfx.load().ignore();
  services.online.signIn().ignore();
  runApp(KacenyApp(services: services, start: kDebugMode ? await _shotsScreen() : null));
}

/// Store screenshots (tool/store_screenshots.sh): a debug build opens the
/// screen named by the `shots.screen` preference ('game' or 'skins') instead
/// of the menu, so a simulator can be shot without tapping through.
Future<String?> _shotsScreen() async => (await SharedPreferences.getInstance()).getString('shots.screen');

/// iOS: effects follow the silent switch, like any casual game.
Future<void> _configureAudioSession() async {
  if (defaultTargetPlatform != TargetPlatform.iOS) {
    return;
  }
  try {
    await AudioPlayer.global.setAudioContext(
      AudioContext(iOS: AudioContextIOS(category: AVAudioSessionCategory.soloAmbient)),
    );
  } catch (error) {
    debugPrint('Kačeny: audio session not configured: $error');
  }
}

class KacenyApp extends StatelessWidget {
  const KacenyApp({super.key, required this.services, this.start});

  final AppServices services;
  final String? start;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kačeny',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: switch (start) {
        'game' => GameScreen(services: services),
        'skins' => SkinsScreen(services: services),
        _ => MenuScreen(services: services),
      },
    );
  }
}
