# KACENY_PLAN.md — handoff pro Claude Code (Opus)

Pracovní název: **Kačeny** (finální jméno otevřené). Mobilní remake principu Moorhuhn v portrait formátu s dotykovým ovládáním. Nepoužívat název Moorhuhn ani jeho grafiku/postavy (ochranná známka Phenomedia) — vlastní kačeny, vlastní jméno.

## 1. Cíl a scope v1

- Arkádová střílečka na čas: cíle (kačeny) letí **shora dolů** přes portrait obrazovku, hráč je sestřeluje tapem.
- Velká kačena **vykukuje z hrany telefonu** (náhodně levá/pravá/horní/dolní hrana), chvíli se ukáže a zase zmizí.
- Různé velikosti kačen → různá rychlost, různé body. Časový limit kola. Leaderboard.
- Jedno kolo = 90 s (konstanta). Po konci: tabulka skóre, uložení, replay.
- **Mimo v1:** multiplayer, power-upy, levely/biomy, reklamy, IAP. Nechat architekturu otevřenou (vrstva `GameConfig`), ale nestavět.

## 2. Tech stack

- Flutter + **Flame** (stejně jako ostatní Ol1novy hry). Orientace zamčená na portrait.
- Stav/konfig: plain Dart, bez těžkého state-managementu. `GameConfig` jako immutable třída konstant (čísly doladit na zařízení).
- Audio: `flame_audio` (nebo `flutter_soloud`, pokud už je v jiném projektu ověřený).
- Haptika: `HapticFeedback` z `services`.
- Lokální leaderboard: `shared_preferences` (top 20 záznamů jako JSON) — není důvod na DB.
- Online leaderboard: balíček `games_services` → Game Center / Google Play Games. Volitelná vrstva, hra musí fungovat bez ní.
- Repo: `lioilsources/<nazev>`, standardní struktura `lib/game/`, `lib/ui/`, `lib/config/`, `assets/`.

## 3. Vstup (nejdůležitější část — číst celé)

Myš z originálu nahrazujeme tapem. Principy:

### 3.1 Výstřel na pointer-down
- NEpoužívat `GestureDetector.onTap` ani Flame `TapCallbacks` jako jediný vstup (gesture arena přidává až ~100 ms a čeká na uvolnění).
- Obalit `GameWidget` do `Listener(onPointerDown: ...)`, `behavior: HitTestBehavior.opaque`. Každý `PointerDownEvent` = jeden výstřel na `event.localPosition` (přepočítat do herních souřadnic přes `game.camera`/viewport).
- Multi-touch: každý pointer samostatně, dva prsty = dva výstřely. Žádné omezení na jeden aktivní pointer.
- Cooldown mezi výstřely **globálně** `shotCooldownMs = 80` (proti spamu i proti dvojitému doteku).

### 3.2 Hitbox: rozšířený kruh + priorita
- Každý cíl má `hitRadius = max(spriteRadius * hitboxScale, minHitRadiusPt)` s `hitboxScale = 1.3`, `minHitRadiusPt = 22` (44 pt průměr — minimum pro dotyk).
- Při výstřelu: najít všechny cíle, jejichž `hitRadius` obsahuje bod výstřelu; vybrat ten s **nejmenší vzdáleností od středu**. Při remíze preferovat cíl v popředí (větší).
- Dvě zóny zásahu:
  - **přesný zásah** (bod uvnitř skutečného spritu / `spriteRadius`) → body + `precisionBonus`
  - **zásah v prstenci** (mezi `spriteRadius` a `hitRadius`) → plné body bez bonusu
- Bez zásahu → zvuk minutí, žádná penalizace (jen spotřeba náboje).

### 3.3 Časová tolerance (lag compensation)
- Dotykový vstup má 50–80 ms latenci; cíle se hýbou. Hráč míří tam, kde cíl **viděl**.
- Každý cíl drží ring buffer posledních ~8 pozic s timestampy. Při výstřelu se testuje pozice v čase `now - inputLatencyMs` (`inputLatencyMs = 60`), interpolovaná.
- Celé v jedné funkci `HitResolver.resolve(shotPoint, shotTime) -> HitResult?`, pokrytá unit testy (viz §8).

### 3.4 Reload
- Zásobník `magazineSize = 8` (jako originál). Po vystřílení se nestřílí, jen klik "prázdno".
- Reload: **swipe dolů kamkoliv** (délka > 40 pt, směr do ±30°) NEBO tap na pás nábojů v dolní HUD zóně. Reload trvá `reloadMs = 400`, během něj nelze střílet.
- Dolní HUD zóna (`bottomSafeZonePt ≈ 72` + safe area) je **mrtvá pro cíle** — nikdy tam nelétají, aby tap na reload nebyl výstřel.
- Vypnutelný auto-reload v nastavení (default off; v Moorhuhnu byl manuální reload součást rytmu).

### 3.5 Ostatní
- Haptika: `lightImpact` na zásah, `mediumImpact` na velkou kačenu, nic na minutí.
- Všechny konstanty v `GameConfig`; připravit debug overlay (toggle v debug buildu) s vizualizací hitboxů a bodu výstřelu + posunuté pozice, aby šlo ladit na telefonu.

## 4. Herní pravidla

### 4.1 Typy cílů
| Typ | Velikost (pt, výška) | Rychlost (pt/s) | Body | Chování |
|---|---|---|---|---|
| tiny | 24 | 120–160 | 10 | daleko v pozadí, nejpomalejší, nejcennější |
| small | 36 | 160–220 | 5 | |
| medium | 52 | 220–300 | 3 | |
| big | 80 | 300–400 | 1 | popředí, rychlá, snadná |
| edge (velká vykukující) | 120+ | — | 5 | vysune se z náhodné hrany na 0.8–1.5 s, zase zajede; jediný cíl, který se nehýbe po dráze |

Hodnoty jsou startovní, doladit hraním. Paralaxa: menší = v pozadí = kreslit níž v z-pořadí.

### 4.2 Pohyb
- Spawn na horní hraně (y < 0) na náhodném x, let směrem dolů. Dráhy: přímá svislá, šikmá, sinusová (zigzag), krátký "dive" se zrychlením. Každý typ má povolenou množinu drah.
- Cíl, který opustí obrazovku dole (nad HUD zónou mizí/odlétá pryč), se bez penalizace odstraní.
- Sestřelený cíl: krátká animace (otočení, pád dolů s gravitací + rotace), ~0.6 s, pak remove. Během pádu už není zásažitelný.

### 4.3 Spawner / obtížnost v kole
- Kolo 90 s rozdělit na 3 fáze (0–30, 30–60, 60–90): roste spawn rate i podíl malých a rychlých cílů. Spawner parametrizovaný křivkou v `GameConfig`.
- Max. současně na obrazovce: 6 (clamp).
- Edge kačena: pravděpodobnostně ~1× za 8–12 s, nikdy dvě najednou.

### 4.4 Skóre a konec
- `score += body (+ precisionBonus = 2 u přesného zásahu)`.
- Combo: 3 zásahy po sobě bez minutí → ×1.5 multiplikátor, 6 → ×2; minutí resetuje. (Jednoduché, dá se vypnout flagem.)
- Posledních 10 s: odpočet s pípáním a vizuální změna HUDu.
- Konec: freeze hry, overlay se skóre, nejlepší skóre, přesnost (%), tlačítka Replay / Leaderboard / Menu.

## 5. Obrazovky a HUD

- **Menu:** Play, Leaderboard, Nastavení (zvuk, haptika, auto-reload), ikona pro login do Game Center / Play Games (pokud `games_services` dostupné).
- **Hra (portrait):** horní HUD (safe area): čas vlevo, skóre vpravo; spodní HUD: pás nábojů (8 ikon) + reload hint. Herní plocha mezi nimi. Pozadí: statická krajina (vertikální, parallax vrstvy volitelně).
- **Game over overlay** (Flame overlays + Flutter widgety).
- **Leaderboard:** lokální top 20 (jméno/iniciály + skóre + datum); záložka Online, pokud přihlášen.

## 6. Leaderboard

- Lokální: `LeaderboardRepository` (interface) → `LocalLeaderboard` (shared_preferences). Zápis po každém kole, dotaz na iniciály jen při dosažení top 20.
- Online: `GamesServicesLeaderboard` přes `games_services` (1 leaderboard "all time"). Submit skóre po kole, pokud přihlášen; selhání ignorovat tiše. ID leaderboardů v konfiguraci, zatím placeholder — Ol1n doplní z App Store Connect / Play Console.

## 7. Grafika a zvuk

- Placeholder spritey v1: jednoduché vektorové kačeny (3 frame flap), vygenerované programově nebo jako PNG v `assets/`; Ol1n později nahradí vlastními assety z ComfyUI pipeline (stejný rozměr/anchor — definovat spec: velikost, 3 snímky, anchor střed, transparentní PNG @2x/@3x).
- Zvuky: výstřel, zásah (dvě varianty), minutí/klik prázdno, reload, pád, odpočet, konec kola. Placeholder free SFX, cesty centralizovat v `SfxCatalog`.

## 8. Testy a kvalita

- Unit testy: `HitResolver` (priorita nejbližšího, prstenec vs. přesný zásah, lag compensation s interpolací, prázdný výsledek), spawner křivka (počty podle fáze), skóre/combo, lokální leaderboard (řazení, limit 20).
- Golden/widget test: HUD layout v portrait pro iPhone SE a velký Android (safe area).
- Manuálně na zařízení: latence výstřelu (subjektivně okamžitá), trefitelnost tiny kačen; podle toho upravit `hitboxScale`, `inputLatencyMs`, `minHitRadiusPt`.

## 9. Milníky (pořadí práce)

1. **Skeleton:** Flutter+Flame projekt, portrait lock, `GameConfig`, `Listener` vstup, debug overlay s křížkem v místě výstřelu. _Hotovo = tap vykreslí bod bez znatelného zpoždění._
2. **Cíle a pohyb:** 4 typy + dráhy, spawner s fázemi, pád po zásahu. _Hotovo = kačeny létají shora dolů, lze je sestřelit._
3. **HitResolver** s rozšířeným hitboxem, prioritou, lag compensation; unit testy. _Hotovo = testy zelené, debug overlay ukazuje hitboxy._
4. **Zásobník + reload** (swipe dolů / tap na pás), HUD, mrtvá zóna.
5. **Edge kačena** z náhodné hrany.
6. **Kolo:** časovač 90 s, skóre, combo, game over overlay, replay.
7. **Lokální leaderboard + menu + nastavení.**
8. **Zvuk + haptika + polish** (animace zásahu, odpočet).
9. **Online leaderboard** přes `games_services` (poslední, volitelné).

Po každém milníku: build na reálný telefon (iOS i Android), krátký commit s popisem. Nepřeskakovat milník 3 — je to jádro, kvůli kterému bude hra fungovat nebo ne.

## 10. Otevřené body pro Ol1na

- Finální název hry a název repa.
- Vlastní grafika kačen a pozadí (spec v §7).
- Leaderboard ID v App Store Connect / Play Console.
- Potvrdit délku kola 90 s a startovní bodování z §4.1 po prvním hraní.
- Zda chtít combo systém v v1 (default: ano, za flagem).
