import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import '../config/game_config.dart';
import '../services/haptics.dart';
import '../services/sfx.dart';
import 'components/debug_overlay.dart';
import 'components/duck_component.dart';
import 'components/edge_duck_component.dart';
import 'components/effects.dart';
import 'components/scenery.dart';
import 'components/target_component.dart';
import 'hud_state.dart';
import 'logic/flight_path.dart';
import 'logic/hit_resolver.dart';
import 'logic/magazine.dart';
import 'logic/reload_swipe.dart';
import 'logic/score_keeper.dart';
import 'logic/spawner.dart';
import 'skins/skin.dart';

enum RoundPhase { playing, paused, over }

/// What a finished round hands to the menus and leaderboards.
class RoundResult {
  const RoundResult({required this.score, required this.shots, required this.hits, required this.bestStreak});

  final int score;
  final int shots;
  final int hits;
  final int bestStreak;

  double get accuracy => shots == 0 ? 0 : hits / shots;
}

/// One round of Kačeny: ducks fly down a portrait screen, the player taps
/// them out of the sky in 90 seconds.
///
/// Input does not go through Flame's tap callbacks: the widget around the
/// [GameWidget] forwards raw pointer events to [onPointerDown] and friends,
/// so a shot fires on touch-down with no gesture-arena delay (§3.1).
class KacenyGame extends FlameGame {
  KacenyGame({
    this.config = GameConfig.defaults,
    required this.sfx,
    required this.haptics,
    this.autoReload = false,
    bool debugOverlay = false,
    this.onRoundFinished,
    this.skin = Skin.vector,
    math.Random? random,
  }) : random = random ?? math.Random(),
       _debugEnabled = debugOverlay;

  static const overlayPause = 'pause';
  static const overlayGameOver = 'gameOver';

  final GameConfig config;
  final Sfx sfx;
  final Haptics haptics;
  final math.Random random;
  final Skin skin;
  bool autoReload;

  /// The skin's duck pictures (wing-beat frames or one); null for the vector skin.
  List<Image>? _duckSprites;
  void Function(RoundResult result)? onRoundFinished;

  late final hud = HudState(
    timeLeft: config.roundSeconds,
    rounds: config.magazineSize,
    magazineSize: config.magazineSize,
  );
  final phase = ValueNotifier(RoundPhase.playing);
  RoundResult? lastResult;

  late final ScoreKeeper score = ScoreKeeper(config);
  late final Magazine magazine = Magazine(size: config.magazineSize, reloadS: config.reloadS);
  late final Spawner spawner = Spawner(config: config, random: random);
  late final ReloadSwipeDetector swipe = ReloadSwipeDetector(
    minDistance: config.reloadSwipeMinPt,
    maxAngleRad: config.reloadSwipeMaxAngleRad,
  );
  late final HitResolver<TargetComponent> resolver = HitResolver(
    config: config,
    targets: () => world.children.whereType<TargetComponent>(),
  );

  /// Game time in seconds; the time base of every position history.
  double clock = 0;

  /// Seconds into the current round.
  double elapsed = 0;

  /// Safe-area insets, set by the screen hosting the game.
  double topInset = 0;
  double bottomInset = 0;

  /// Lowest y a target may reach; below it is the ammo belt (§3.4).
  double get playBottom => size.y - config.bottomSafeZonePt - bottomInset;

  /// Where the edge duck can appear: between the top HUD and the ammo belt.
  Rect get edgeArea => Rect.fromLTRB(0, topInset + config.topHudPt, size.x, playBottom);

  // Pointer timing: wall clock of the last update, to place a shot between
  // frames, and of the last accepted shot, for the cooldown.
  final Stopwatch _wall = Stopwatch()..start();
  Duration _lastUpdateWall = Duration.zero;
  Duration? _lastShotStamp;

  int _lastBeepSecond = -1;
  EdgeDuckComponent? _edgeDuck;

  bool _debugEnabled;
  DebugOverlay? _debug;

  bool get debugEnabled => _debugEnabled;

  set debugEnabled(bool value) {
    _debugEnabled = value;
    if (!isLoaded) {
      return;
    }
    if (value && _debug == null) {
      world.add(_debug = DebugOverlay());
    } else if (!value && _debug != null) {
      _debug!.removeFromParent();
      _debug = null;
    }
  }

  @override
  Color backgroundColor() => const Color(0xFF7EC8F0);

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    if (skin.isVector) {
      world.addAll([Background(), Clouds(random)]);
    } else {
      images.prefix = 'assets/';
      final background = images.load(skin.backgroundAsset);
      _duckSprites = await Future.wait(skin.duckFrameAssets.map(images.load));
      world.add(PictureBackground(await background));
    }
    world.add(Reeds(random.nextInt(1 << 30)));
    debugEnabled = _debugEnabled;
    startRound();
  }

  void setInsets({required double top, required double bottom}) {
    topInset = top;
    bottomInset = bottom;
  }

  // ---- Round flow ---------------------------------------------------------

  void startRound() {
    for (final c in world.children.toList()) {
      if (c is TargetComponent || c is ImpactFx || c is ScorePopup || c is FeatherBurst) {
        c.removeFromParent();
      }
    }
    _edgeDuck = null;
    score.reset();
    magazine.reset();
    spawner.reset();
    swipe.clear();
    _debug?.shots.clear();
    elapsed = 0;
    _lastBeepSecond = -1;
    _lastShotStamp = null;
    lastResult = null;
    overlays.removeAll([overlayPause, overlayGameOver]);
    phase.value = RoundPhase.playing;
    _syncHud();
    resumeEngine();
  }

  void pause() {
    if (phase.value != RoundPhase.playing) {
      return;
    }
    phase.value = RoundPhase.paused;
    swipe.clear();
    pauseEngine();
    overlays.add(overlayPause);
  }

  void resume() {
    if (phase.value != RoundPhase.paused) {
      return;
    }
    overlays.remove(overlayPause);
    phase.value = RoundPhase.playing;
    resumeEngine();
  }

  void _finishRound() {
    phase.value = RoundPhase.over;
    swipe.clear();
    sfx.roundEnd();
    final result = RoundResult(score: score.score, shots: score.shots, hits: score.hits, bestStreak: score.bestStreak);
    lastResult = result;
    _syncHud();
    pauseEngine();
    overlays.add(overlayGameOver);
    onRoundFinished?.call(result);
  }

  // ---- Frame --------------------------------------------------------------

  @override
  void update(double dt) {
    // Long hitches (app switch, debugger) would teleport ducks.
    dt = math.min(dt, 1 / 20);
    _lastUpdateWall = _wall.elapsed;
    if (phase.value == RoundPhase.playing) {
      clock += dt;
      elapsed += dt;
      if (magazine.update(dt)) {
        hud.reloadProgress.value = 0;
      }
      _spawn(dt);
      _countdown();
    }
    super.update(dt);
    if (phase.value == RoundPhase.playing && elapsed >= config.roundSeconds) {
      _finishRound();
      return;
    }
    _syncHud();
  }

  void _spawn(double dt) {
    final edgeActive = _edgeDuck != null && !_edgeDuck!.done;
    final flying = world.children.whereType<DuckComponent>().where((d) => d.flying).length;
    final plan = spawner.update(dt, elapsed: elapsed, flying: flying, edgeActive: edgeActive);
    for (final kind in plan.ducks) {
      final spec = config.ducks[kind]!;
      final r = spec.heightPt * 0.62; // wing reach
      final path = FlightPath.random(
        random: random,
        allowed: spec.paths,
        startY: -spec.heightPt,
        speed: spawner.speedFor(kind, elapsed),
        minX: r,
        maxX: size.x - r,
      );
      world.add(
        DuckComponent(kind: kind, spec: spec, path: path, config: config, random: random, sprites: _duckSprites),
      );
    }
    if (plan.edgeDuck) {
      world.add(_edgeDuck = EdgeDuckComponent(spec: config.edge, config: config, random: random));
    }
  }

  void _countdown() {
    final left = (config.roundSeconds - elapsed).ceil();
    if (left <= config.countdownSeconds && left > 0 && left != _lastBeepSecond) {
      _lastBeepSecond = left;
      sfx.countdown();
    }
  }

  void _syncHud() {
    final left = math.max(0, (config.roundSeconds - elapsed).ceil());
    // Countdown first: the timer reads it when timeLeft notifies.
    hud.countdown.value = left <= config.countdownSeconds;
    hud.timeLeft.value = left;
    hud.score.value = score.score;
    hud.rounds.value = magazine.rounds;
    hud.reloading.value = magazine.reloading;
    if (magazine.reloading) {
      hud.reloadProgress.value = magazine.reloadProgress;
    }
    hud.multiplier.value = score.multiplier;
  }

  // ---- Input (§3.1) -------------------------------------------------------

  /// Converts a position local to the [GameWidget] into world coordinates.
  Vector2 toWorld(Offset local) => camera.globalToLocal(Vector2(local.dx, local.dy));

  void onPointerDown(PointerDownEvent event) {
    final p = toWorld(event.localPosition);
    swipe.down(event.pointer, p);
    if (phase.value != RoundPhase.playing) {
      return;
    }
    if (p.y >= playBottom) {
      // The ammo belt: a tap there reloads, never shoots.
      requestReload();
      return;
    }
    _shoot(p, event.timeStamp);
  }

  void onPointerMove(PointerMoveEvent event) {
    if (swipe.move(event.pointer, toWorld(event.localPosition)) && phase.value == RoundPhase.playing) {
      requestReload();
    }
  }

  void onPointerUp(PointerEvent event) => swipe.up(event.pointer);

  void requestReload() {
    if (magazine.startReload()) {
      sfx.reload();
      _syncHud();
    }
  }

  void _shoot(Vector2 point, Duration stamp) {
    final last = _lastShotStamp;
    if (last != null && (stamp - last).inMicroseconds < config.shotCooldownMs * 1000) {
      return;
    }
    _lastShotStamp = stamp;

    if (!magazine.fire()) {
      sfx.empty();
      if (autoReload) {
        requestReload();
      }
      return;
    }
    sfx.shot();

    // The touch happened somewhat after the last frame; the clock only
    // advances per frame. Capped so a stall cannot shift it far.
    final sinceFrame = math.min((_wall.elapsed - _lastUpdateWall).inMicroseconds / 1e6, 1 / 30);
    final shotTime = clock + sinceFrame;
    final result = resolver.resolve(point, shotTime);

    if (_debug != null) {
      final then = shotTime - config.inputLatencyS;
      _debug!.addShot(
        DebugShot(
          point: point.clone(),
          hit: result != null,
          at: clock,
          compensated: [
            for (final t in world.children.whereType<TargetComponent>().where((t) => t.hittable))
              (t.position.clone(), t.positionAt(then), config.hitRadiusFor(t.spriteRadius)),
          ],
        ),
      );
    }

    if (result == null) {
      score.miss();
      sfx.miss();
      world.add(ImpactFx(point));
    } else {
      final target = result.target;
      final gained = score.hit(points: target.points, precise: result.precise);
      target.onShot();
      if (target.isBig) {
        haptics.bigHit();
        sfx.hitEdge();
      } else {
        haptics.hit();
        sfx.hit();
        sfx.fall();
      }
      world.addAll([
        ImpactFx(point, hit: true),
        FeatherBurst(target.position.clone(), random, scale: target.spriteRadius / 20, count: target.isBig ? 12 : 7),
        ScorePopup(
          target.position.clone() - Vector2(0, target.spriteRadius + 8),
          gained,
          precise: result.precise,
          multiplier: score.multiplier,
        ),
      ]);
    }
    if (magazine.empty && autoReload) {
      requestReload();
    }
    _syncHud();
  }
}
