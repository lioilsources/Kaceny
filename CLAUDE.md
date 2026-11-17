# Kačeny

<!-- Max 80 řádků. Co se nevejde, jde do docs/ a sem jeden odkaz. Veřejné repo: žádné LAN IP, domovské cesty, ID. -->

## Účel
Portrétní arkádová střílečka pro iOS a Android (Flutter + Flame): kachny letí dolů
obrazovkou, 90 sekund je sestřeluješ ťuknutím. Bundle `com.ol1n.kaceny`.

## Build a test
```
flutter analyze --no-fatal-infos
flutter test --exclude-tags golden   # jako CI
flutter test --update-goldens        # po zamýšlené změně HUD
dart run tool/gen_sfx.dart           # placeholder zvuky
```
Gate před pushem: `flutter analyze` + `flutter test` (CI v `.github/workflows/ci.yml`).

## Mapa
- `lib/config/game_config.dart`: všechna laditelná čísla
- `lib/game/logic/`: čistý Dart s unit testy (HitResolver, Spawner, ScoreKeeper, …)
- `lib/game/`: Flame hra a komponenty
- `lib/ui/`: obrazovky, HUD, overlaye
- `lib/services/`: nastavení, SFX, haptika, žebříčky
- `tool/`: SFX generátor, skripty pro App Store / Play metadata, screenshoty
- `store/`: texty a obrázky do obchodů; `docs/`: privacy a support (GitHub Pages)
- `Prompts/`: plán a monetizace

## Invarianty
- `lib/game/logic/` je čistý Dart bez importů Flame/Flutter a je pokrytý unit testy.
- Výstřel se odpaluje na pointer-down (`Listener` kolem `GameWidget`).

## Kam dál
README (ladění na telefonu, otevřené body), `Prompts/00-KACENY_PLAN.md`
