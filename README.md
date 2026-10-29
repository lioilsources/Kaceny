# Kačeny

Working title. Portrait arcade shooter for iOS and Android (Flutter + Flame):
ducks fly down the screen, tap them out of the sky in 90 seconds. Plan and
rationale: `Prompts/00-KACENY_PLAN.md`.

## Run

    flutter run
    flutter test                    # unit + HUD golden tests
    flutter test --update-goldens   # after an intended HUD change
    dart run tool/gen_sfx.dart      # regenerate the placeholder sounds

## Map

- `lib/config/game_config.dart` — every tunable number (hitbox, latency,
  spawner phases, duck table, combo, magazine).
- `lib/game/logic/` — pure Dart, unit tested: `HitResolver` (§3.2–3.3),
  `PositionHistory`, `FlightPath`, `Spawner`, `ScoreKeeper`, `Magazine`,
  `ReloadSwipeDetector`.
- `lib/game/` — Flame game and components (ducks, edge duck, scenery,
  effects, debug overlay).
- `lib/ui/` — Flutter screens, HUD, overlays. `GameScreen` wraps the
  `GameWidget` in a `Listener`: shots fire on pointer-down.
- `lib/services/` — settings, SFX (`SfxCatalog`), haptics, leaderboards.

## Tuning on a phone

Debug builds: Settings → "Debug: hitboxy a výstřely" draws hit circles
(red), sprite circles (green), shots (cyan / green on a hit) and where each
target was tested after lag compensation (yellow). Adjust `hitboxScale`,
`inputLatencyMs`, `minHitRadiusPt` in `GameConfig`.

## Still open

- Final name / repo (`lioilsources/<name>`), bundle id is `com.ol1n.kaceny`.
- Real art per `assets/SPRITES.md`; real SFX under the names in `SfxCatalog`.
- Leaderboard IDs: `GamesServicesLeaderboard.iosLeaderboardId` (App Store
  Connect, placeholder `kaceny.alltime`), `androidLeaderboardId` and
  `android/app/src/main/res/values/games-ids.xml` (Play Console).
