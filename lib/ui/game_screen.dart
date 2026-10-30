import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../app_services.dart';
import '../config/game_config.dart';
import '../game/kaceny_game.dart';
import '../game/skins/skin.dart';
import 'game_over_overlay.dart';
import 'hud.dart';
import 'leaderboard_screen.dart';
import 'pause_overlay.dart';
import 'theme.dart';

/// Hosts one [KacenyGame]: raw pointer input, the HUD and the overlays.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.services, this.config = GameConfig.defaults});

  final AppServices services;
  final GameConfig config;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final KacenyGame game;
  late final AppLifecycleListener _lifecycle;

  AppServices get services => widget.services;

  @override
  void initState() {
    super.initState();
    final s = services.settings;
    game = KacenyGame(
      config: widget.config,
      sfx: services.sfx,
      haptics: services.haptics,
      autoReload: s.autoReload,
      debugOverlay: s.debugOverlay,
      onRoundFinished: (result) => services.online.submit(result.score),
      skin: Skin.byId(s.skin),
    );
    s.addListener(_applySettings);
    // Leaving the app mid-round pauses it.
    _lifecycle = AppLifecycleListener(onInactive: game.pause, onHide: game.pause);
  }

  void _applySettings() {
    game.autoReload = services.settings.autoReload;
    game.debugEnabled = services.settings.debugOverlay;
  }

  @override
  void dispose() {
    services.settings.removeListener(_applySettings);
    _lifecycle.dispose();
    super.dispose();
  }

  void _toMenu() {
    services.sfx.ui();
    Navigator.of(context).pop();
  }

  void _toLeaderboard(int? rank) {
    services.sfx.ui();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LeaderboardScreen(services: services, highlightRank: rank),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    game.setInsets(top: padding.top, bottom: padding.bottom);
    final config = widget.config;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Every touch-down is a shot, straight from the pointer stream —
          // no gesture arena, no waiting for the finger to lift (§3.1).
          Positioned.fill(
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: game.onPointerDown,
              onPointerMove: game.onPointerMove,
              onPointerUp: game.onPointerUp,
              onPointerCancel: game.onPointerUp,
              child: GameWidget<KacenyGame>(
                game: game,
                overlayBuilderMap: {
                  KacenyGame.overlayPause: (context, game) => PauseOverlay(
                    onResume: () {
                      services.sfx.ui();
                      game.resume();
                    },
                    onRestart: () {
                      services.sfx.ui();
                      game.startRound();
                    },
                    onMenu: _toMenu,
                  ),
                  KacenyGame.overlayGameOver: (context, game) => GameOverOverlay(
                    result: game.lastResult!,
                    services: services,
                    onReplay: () {
                      services.sfx.ui();
                      game.startRound();
                    },
                    onLeaderboard: _toLeaderboard,
                    onMenu: _toMenu,
                  ),
                },
              ),
            ),
          ),
          ValueListenableBuilder<RoundPhase>(
            valueListenable: game.phase,
            builder: (context, phase, _) {
              if (phase != RoundPhase.playing) {
                return const SizedBox.shrink();
              }
              return Stack(
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: GameHud(
                        state: game.hud,
                        topHeight: config.topHudPt,
                        bottomHeight: config.bottomSafeZonePt,
                      ),
                    ),
                  ),
                  // Above the Listener in the stack, so tapping it never fires.
                  Positioned(
                    top: padding.top + (config.topHudPt - 44) / 2,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox.square(
                        dimension: 44,
                        child: IconButton.filled(
                          style: IconButton.styleFrom(backgroundColor: KColors.pill),
                          onPressed: game.pause,
                          icon: const Icon(Icons.pause_rounded, color: Colors.white),
                          tooltip: 'Pauza',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
