# Kačeny → Babylon.js: mapa portu

Webový klient Kačen v TypeScriptu nad Babylon.js. Zdroj pravdy je Flutter appka v kořeni repa
(pravidla v `lib/config/` a `lib/game/logic/`). Plán: `DevConventions/Prompts/06-PLAN-babylon-web.md`,
kostra ze šablony `DevConventions/templates/babylon`, vzor: `ChrestysSkatepark/babylon` (RattleRamp).
Stav: **F0 (audit a spike)**. Hostování: GitHub Pages repa, hra pod `/play/`, `docs/` (privacy, support) zůstává v kořeni.

## Úrovně parity

- **P0**: diskrétní pravidla (skóre, combo, zásobník, gesto přebití, výběr cíle), shoda přes zlaté vektory z Dartu.
- **P1**: spojitý pohyb (dráhy letu, pád, historie poloh): zlaté vektory na 1e-9, v praxi přesně (viz Odchylky 1).
- **P2**: vzhled: stejná scéna (obloha, slunce, kopce, rybník), stejné vektorové kachny, HUD. Ne pixel po pixelu.

## Vrstvy

| Složka | Obsah | Hlídá |
|---|---|---|
| `src/rules/` | čistá pravidla: config, dráhy, historie, zásah, zásobník, skóre, spawner, celé kolo (`round.ts`) | ESLint: bez Babylonu, DOM, `game/`, `ui/` |
| `src/game/` | Babylon scéna (ortografická kamera v pt, y dolů), herní smyčka s pevným krokem 1/120 s, vstup | — |
| `src/ui/` | DOM a Canvas 2D: HUD, konec kola, efekty, kreslení kachen a pozadí | ESLint: bez Babylonu a `game/` |

## Mapa Dart → TS po souborech

### Čistý Dart (`lib/config` + `lib/game/logic` 834 ř. bez Flutteru a Flame; paleta a skiny jen s `dart:ui`) → `src/rules/`

| Dart | ř. | TS | Parita | Stav |
|---|---|---|---|---|
| `lib/config/game_config.dart` | 255 | `game-config.ts` + `generated/game-config.json` | P0 | F0: hodnoty dumpuje Dart, ne ručně |
| `lib/game/logic/flight_path.dart` | 147 | `flight-path.ts` | P1 | F0, vektory |
| `lib/game/logic/position_history.dart` | 77 | `position-history.ts` | P1 | F0, vektory |
| `lib/game/logic/hit_resolver.dart` | 90 | `hit-resolver.ts` | P0 | F0, testy podle `test/logic/hit_resolver_test.dart` |
| `lib/game/logic/magazine.dart` | 56 | `magazine.ts` | P0 | F0, vektory |
| `lib/game/logic/score_keeper.dart` | 62 | `score-keeper.ts` | P0 | F0, vektory |
| `lib/game/logic/reload_swipe.dart` | 53 | `reload-swipe.ts` | P0 | F0, vektory |
| `lib/game/logic/spawner.dart` | 94 | `spawner.ts` | P0 | F0; vektory v F1 (potřebují zdroj náhody nezávislý na `dart:math`) |
| `lib/game/render/palette.dart` | 39 | `ui/generated/palette.ts` | P2 | F0, `npm run gen` čte zdroják (`dart:ui` v Dart VM neběží) |
| `lib/game/skins/skin.dart`, `skin_catalog.dart` (generovaný) | 176 | `rules/skins.ts` | P0 | F3, jen balíček zdarma |

### Flame (`lib/game/` + `render/duck_painter.dart`, 1 431 ř.) → `src/rules/round.ts` + `src/game/`

| Dart | ř. | TS | Stav |
|---|---|---|---|
| `kaceny_game.dart` | 389 | `rules/round.ts` (průběh kola, spawn, střelba) + `game/main.ts` (smyčka, vstup) | F0 bez pauzy a edge kachny |
| `components/duck_component.dart` | 170 | `rules/round.ts` (`Duck`: let, pád, únik) + `game/scene.ts` | F0 |
| `components/target_component.dart` | 34 | `Duck` implementuje `HitTarget` | F0 |
| `components/edge_duck_component.dart` | 156 | `rules/edge-duck.ts` + scéna | F2 |
| `components/effects.dart` | 148 | `ui/fx.ts` (kroužek, body) | F0; peří F3 |
| `components/scenery.dart` | 223 | `ui/backdrop.ts` | F0 obloha, slunce, kopce, voda; mraky a rákosí F3 |
| `components/debug_overlay.dart` | 76 | `?debug` | F2 |
| `render/duck_painter.dart` | 216 | `ui/duck-paint.ts` (`DuckPainter` 1:1), `EdgeDuckPainter` v F2 | F0 |
| `hud_state.dart` | 19 | `ui/hud.ts` (`HudState`) | F0 |

### Flutter UI (`lib/ui/`, 1 566 ř.) → `src/ui/` (DOM + CSS)

| Dart | ř. | Stav |
|---|---|---|
| `hud.dart` | 274 | F0 základ (čas, skóre, combo, pás nábojů, přebíjení); pulz odpočtu F2 |
| `game_screen.dart` | 172 | F0 vstup na pointer-down; pauza F2 |
| `game_over_overlay.dart` | 223 | F0 jednoduchá karta; plná F2 |
| `menu_screen.dart` | 168 | F2 |
| `pause_overlay.dart` | 52 | F2 |
| `settings_screen.dart` | 48 | F2 (automatické přebití, zvuk) |
| `skins_screen.dart` | 440 | F3, bez nákupů |
| `leaderboard_screen.dart` | 138 | F3 jen místní žebříček |
| `theme.dart` | 51 | CSS proměnné |

### Služby (`lib/services/`, 576 ř.)

| Dart | Web |
|---|---|
| `settings.dart` (shared_preferences) | `localStorage` (F2) |
| `sfx.dart`, `sfx_catalog.dart` (flame_audio) | Web Audio, stejné WAV (F3) |
| `haptics.dart` | `navigator.vibrate` kde je, jinak nic (F3) |
| `leaderboard/local_leaderboard.dart` | `localStorage` (F3) |
| `leaderboard/games_services_leaderboard.dart` | **vypouští se** (Game Center / Play Games na webu nejsou) |
| `skin_store.dart` (in_app_purchase) | **vypouští se**: na webu jen balíček zdarma |

## Zlaté vektory

`dart run tool/dump_vectors.dart` (z kořene repa, po `flutter pub get`). CI job `golden` je přegeneruje a porovná celé
`babylon/test/golden/` a `babylon/src/rules/generated/` bajt po bajtu.

| Soubor | Co pokrývá |
|---|---|
| `flight-path.json` | 24 drah (4 druhy × 6), polohy po 0,1 s do 3 s |
| `history.json` | 10 historií se stejnými i rostoucími časy, dotazy mimo rozsah i mezi vzorky |
| `magazine.json` | 10 sekvencí výstřel / přebití / čas, stav po každém kroku |
| `score.json` | 20 sérií zásahů a minutí: body za každý, skóre, nejdelší série |
| `swipe.json` | 60 vektorů gesta přebití |
| `generated/game-config.json` | všechny výchozí hodnoty `GameConfig` (TS je importuje) |

## Funkce

Jedna řádka na funkci = jedno video (plán 06, kap. 5a). Id funkce = `?demo=<id>` (F2).

| Id | Funkce | W | F |
|---|---|---|---|
| `tap` | ťuknutí sestřelí kachnu, pád s rotací, body nad ní | | |
| `precision` | zásah do kachny = přesný (+2, zlatě), do okraje = obyčejný | | |
| `sizes` | čtyři velikosti: malá a vzdálená = víc bodů | | |
| `paths` | dráhy: rovně, šikmo s odrazem, vlnovka, střemhlav | | |
| `combo` | série zásahů ×1,5 a ×2, minutí sérii smaže | | |
| `reload` | 8 nábojů, přebití tahem dolů nebo ťuknutím na pás | | |
| `edge-duck` | kachna vykoukne z okraje, 5 bodů | | |
| `phases` | tři fáze kola: víc a rychlejších kachen | | |
| `countdown` | posledních 10 s pípá a čas zčervená | | |
| `game-over` | konec kola: skóre, přesnost, série | | |
| `skins` | skiny zdarma (12 stylů) | | |
| `leaderboard` | místní žebříček | | |
| `web-play` | odkaz z olin.now → hraje se za pár vteřin | | |

## Co se na webu vypouští

- **Nákupy skinů** (`in_app_purchase`, 100 placených skinů v 8 balíčcích): na webu jen balíček zdarma, bez obchodu. Placené
  skiny by na webu byly zadarmo a assety by měly 20 MB.
- **Žebříčky obchodů** (Game Center, Play Games): jen místní žebříček.
- **Haptika** tam, kde prohlížeč neumí `navigator.vibrate` (iOS Safari).

## Assety

| Co | Velikost | Web |
|---|---|---|
| `assets/skins/` placené balíčky (100 skinů) | 19,9 MB | ne |
| `assets/skins/` balíček zdarma (12 skinů, z toho 2 animované) | 2,3 MB | F3, dotahuje se až po výběru skinu |
| `assets/audio/` (11 WAV) | 0,4 MB | F3, po prvním snímku |
| vektorová kachna a scéna | kód | F0, výchozí |

`npm run assets` kopíruje před buildem, v gitu je jen Flutter kopie. F0 nekopíruje nic.

## Měření F0 (lokálně, 23. 11. 2026)

Chromium headless, viewport 430×932, mediány ze 3 běhů. Pomalá síť = 4 Mbit/s, RTT 100 ms, CPU ×4.
Flutter web = `flutter build web --release` v zahozené kopii (repo nemá platformu web).

| | Flutter web | Babylon spike |
|---|---|---|
| Build | 63 MB (z toho 22 MB skiny) | 1,5 MB |
| Přeneseno do 1. snímku | 5,3 MB | 0,30 MB |
| 1. snímek, rychlá síť | 0,70 s | 0,21 s |
| 1. snímek, pomalá síť + CPU ×4 | 11,5 s | 1,2 s |

Měření na telefonu zbývá.

## Odchylky

1. **float32 polohy:** `Vector2` z `vector_math` ukládá `Float32List`. Každý zápis polohy (`setValues`, `sub`) se v Dartu
   zaokrouhlí na float32, aritmetika mezi tím je double. TS to dělá stejně přes `Math.fround` (`rules/vec.ts`); bez toho
   se dráhy rozjely v 7. platné číslici. Našly to zlaté vektory.
2. **Pevný krok 1/120 s** místo Flame `dt` za snímek (strop 1/20 s zůstává). Výsledek kola tak nezávisí na FPS.
3. **Náhoda:** `dart:math` `Random` se nekopíruje. Hra bere `GameRandom` (`?seed=` = opakovatelné kolo pro videa),
   vektory náhodu nepoužívají, dostávají explicitní tvary.
4. **Paleta** se čte ze zdrojáku `palette.dart` (`dart:ui` v Dart VM nejde spustit), ne z dumpu. Hlídá ji `config-sync`.
5. **Kořen repa:** Flutter appka je v kořeni, ne v podsložce. Šablona s tím zatím nepočítá; cesty v `web.yml`
   a `copy-assets.ts` jsou upravené ručně.
