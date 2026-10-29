import 'dart:math' as math;

/// The four flying duck sizes. Smaller = further away = slower, worth more.
enum DuckKind { tiny, small, medium, big }

/// Shapes of a flight from the top edge downwards.
enum FlightPathKind { straight, diagonal, sine, dive }

/// Static description of one duck size (§4.1 of the plan).
class DuckSpec {
  const DuckSpec({
    required this.heightPt,
    required this.minSpeed,
    required this.maxSpeed,
    required this.points,
    required this.paths,
  });

  /// Sprite height in logical points. The sprite radius is half of it.
  final double heightPt;

  /// Base downward speed range in pt/s.
  final double minSpeed;
  final double maxSpeed;
  final int points;
  final List<FlightPathKind> paths;

  double get spriteRadius => heightPt / 2;
}

/// The duck that peeks in from a screen edge and hides again.
class EdgeDuckSpec {
  const EdgeDuckSpec({
    this.heightPt = 128,
    this.points = 5,
    this.minShowS = 0.8,
    this.maxShowS = 1.5,
    this.slideS = 0.22,
    this.minIntervalS = 8,
    this.maxIntervalS = 12,
    this.firstDelayS = 5,
    this.revealFraction = 0.62,
  });

  final double heightPt;
  final int points;

  /// How long it stays fully out, randomised between the two.
  final double minShowS;
  final double maxShowS;

  /// Duration of the slide in and of the slide out.
  final double slideS;

  /// Gap between two appearances, measured from the end of the previous one.
  final double minIntervalS;
  final double maxIntervalS;

  /// Delay before the first appearance in a round.
  final double firstDelayS;

  /// Fraction of the head's height visible when fully out.
  final double revealFraction;

  double get spriteRadius => heightPt / 2;
}

/// One third of a round: how often ducks come and which ones.
class PhaseSpec {
  const PhaseSpec({required this.startS, required this.spawnIntervalS, required this.weights, this.speedScale = 1});

  /// Round time (seconds from start) at which this phase begins.
  final double startS;

  /// Seconds between two spawns.
  final double spawnIntervalS;

  /// Relative spawn probability per kind; need not sum to one.
  final Map<DuckKind, double> weights;

  /// Multiplies every duck's speed spawned in this phase.
  final double speedScale;
}

/// Combo step: [hits] in a row without a miss give [multiplier].
class ComboTier {
  const ComboTier(this.hits, this.multiplier);

  final int hits;
  final double multiplier;
}

/// Every tunable number of the game in one immutable place.
///
/// Values are starting points from the plan; tune them on a real phone. The
/// debug overlay (Settings → Debug, debug builds only) draws hitboxes and the
/// lag-compensated positions so that [hitboxScale], [inputLatencyMs] and
/// [minHitRadiusPt] can be judged by eye.
class GameConfig {
  const GameConfig({
    this.roundSeconds = 90,
    this.countdownSeconds = 10,
    this.shotCooldownMs = 80,
    this.hitboxScale = 1.3,
    this.minHitRadiusPt = 22,
    this.inputLatencyMs = 60,
    this.historySize = 10,
    this.magazineSize = 8,
    this.reloadMs = 400,
    this.reloadSwipeMinPt = 40,
    this.reloadSwipeMaxAngleDeg = 30,
    this.bottomSafeZonePt = 72,
    this.topHudPt = 52,
    this.maxOnScreen = 6,
    this.precisionBonus = 2,
    this.comboEnabled = true,
    this.comboTiers = const [ComboTier(3, 1.5), ComboTier(6, 2)],
    this.fallDurationS = 0.6,
    this.fallGravity = 1500,
    this.escapeFadeS = 0.22,
    this.ducks = defaultDucks,
    this.phases = defaultPhases,
    this.edge = const EdgeDuckSpec(),
  });

  /// Length of one round.
  final int roundSeconds;

  /// The last seconds that beep and turn the HUD red.
  final int countdownSeconds;

  /// Minimum gap between two shots, across all fingers.
  final int shotCooldownMs;

  /// Hit circle = sprite circle × this, but never below [minHitRadiusPt].
  final double hitboxScale;

  /// 22 pt radius = 44 pt diameter, the smallest comfortable touch target.
  final double minHitRadiusPt;

  /// How far back in time a shot is tested (touch latency compensation).
  final int inputLatencyMs;

  /// Positions remembered per target for the lag compensation.
  final int historySize;

  final int magazineSize;
  final int reloadMs;

  /// A downward swipe at least this long, within this angle of vertical,
  /// reloads.
  final double reloadSwipeMinPt;
  final double reloadSwipeMaxAngleDeg;

  /// Bottom HUD strip (ammo belt) above the safe-area inset. No target ever
  /// enters it, so tapping it reloads instead of shooting.
  final double bottomSafeZonePt;

  /// Height of the top HUD row below the safe-area inset (layout only;
  /// ducks fly underneath it).
  final double topHudPt;

  /// Flying ducks alive at once (falling ones and the edge duck excluded).
  final int maxOnScreen;

  /// Extra points for a hit inside the sprite itself, not just the ring.
  final int precisionBonus;

  final bool comboEnabled;
  final List<ComboTier> comboTiers;

  /// Shot-down animation length and the gravity it falls with.
  final double fallDurationS;
  final double fallGravity;

  /// Fade of a duck that reached the bottom HUD line and flies off.
  final double escapeFadeS;

  final Map<DuckKind, DuckSpec> ducks;
  final List<PhaseSpec> phases;
  final EdgeDuckSpec edge;

  static const GameConfig defaults = GameConfig();

  double get inputLatencyS => inputLatencyMs / 1000;
  double get shotCooldownS => shotCooldownMs / 1000;
  double get reloadS => reloadMs / 1000;
  double get reloadSwipeMaxAngleRad => reloadSwipeMaxAngleDeg * math.pi / 180;

  /// Hit circle radius for a sprite of [spriteRadius].
  double hitRadiusFor(double spriteRadius) => math.max(spriteRadius * hitboxScale, minHitRadiusPt);

  /// The phase active at [elapsedS] seconds into the round.
  PhaseSpec phaseAt(double elapsedS) {
    var current = phases.first;
    for (final phase in phases) {
      if (elapsedS >= phase.startS) {
        current = phase;
      }
    }
    return current;
  }

  static const defaultDucks = <DuckKind, DuckSpec>{
    DuckKind.tiny: DuckSpec(
      heightPt: 24,
      minSpeed: 120,
      maxSpeed: 160,
      points: 10,
      paths: [FlightPathKind.straight, FlightPathKind.sine],
    ),
    DuckKind.small: DuckSpec(
      heightPt: 36,
      minSpeed: 160,
      maxSpeed: 220,
      points: 5,
      paths: [FlightPathKind.straight, FlightPathKind.diagonal, FlightPathKind.sine],
    ),
    DuckKind.medium: DuckSpec(
      heightPt: 52,
      minSpeed: 220,
      maxSpeed: 300,
      points: 3,
      paths: [FlightPathKind.diagonal, FlightPathKind.sine, FlightPathKind.dive],
    ),
    DuckKind.big: DuckSpec(
      heightPt: 80,
      minSpeed: 300,
      maxSpeed: 400,
      points: 1,
      paths: [FlightPathKind.straight, FlightPathKind.diagonal, FlightPathKind.dive],
    ),
  };

  /// 0–30 s warm-up, 30–60 s busier, 60–90 s fast and small.
  static const defaultPhases = <PhaseSpec>[
    PhaseSpec(
      startS: 0,
      spawnIntervalS: 1.1,
      weights: {DuckKind.tiny: 1, DuckKind.small: 2, DuckKind.medium: 3, DuckKind.big: 4},
    ),
    PhaseSpec(
      startS: 30,
      spawnIntervalS: 0.8,
      weights: {DuckKind.tiny: 2, DuckKind.small: 3, DuckKind.medium: 3, DuckKind.big: 2},
      speedScale: 1.1,
    ),
    PhaseSpec(
      startS: 60,
      spawnIntervalS: 0.55,
      weights: {DuckKind.tiny: 3, DuckKind.small: 4, DuckKind.medium: 2, DuckKind.big: 1},
      speedScale: 1.2,
    ),
  ];
}
