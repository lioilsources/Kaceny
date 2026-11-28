# Anonymous gameplay statistics

Kačeny sends a small set of anonymous gameplay events through
[`ol1n_telemetry`](https://github.com/lioilsources/Ol1nTelemetry) so the
owner can see what new players do in their first session, how rounds go,
which skins are played and bought, and when players stop. This file is the
**event dictionary**: the constant `kacenyDictionary`
(`lib/services/telemetry.dart`) and this document list exactly the same
events and properties, and `test/telemetry_test.dart` fails when they drift
apart.

Adding an event or a property is a change to the privacy policy
(`docs/privacy.html`) and to the store privacy answers. Ask the owner first,
and change the dictionary at most once per release.

## Rules

The rules of `ol1n_telemetry` apply unchanged (see its README):

- **No persistent identifier.** No install, device or advertising id. Each
  session gets a random 128-bit id that lives in memory; unsent events in the
  offline queue carry it and are deleted once sent.
- **Cohorts are computed on the device.** Only bands leave it.
- **Only enums, bands and numbers.** No free text, no initials from the
  leaderboard, no device model. Skin and pack ids are catalogue constants.
- **No key, no network.** Without `TELEMETRY_KEY` and an `https`
  `TELEMETRY_HOST` nothing is recorded or sent, and the settings switch is
  hidden. Local builds, forks and tests are silent.
- **The game never waits**, **off wipes the queue at once**, and
  **measuring never steers the game**: nothing in the game reads anything
  back. The game only reports through callbacks (`onRoundStarted`,
  `onRoundFinished`, `onReload` on `KacenyGame`) to `KacenyTelemetry`.
- The queue lives in the app's own `shared_preferences` under `telemetry_*`
  keys (`PrefsTelemetryStore`).

## Screens

Pushed screens are named routes (`kScreenRoutes`): `menu`, `skins`,
`leaderboard`, `settings`. The game route reports the state of the round:
`play` (a round on screen), `pause` (pause menu), `result` (round over).
Leaving the app mid-round pauses the round first; that `pause` is reported
only when the player comes back, so a session that ends mid-round ends on
`play`.

## Rounds

A round is the flow `run_start` / `run_end`, with the names shared by all
ol1n games (plan §6.3): `result`, `secs`, `level`, `cause`.

- `run_start` when a round begins: PLAY in the menu, REPLAY on the result
  screen, START OVER in the pause menu.
- `run_end` when it ends: `death` (the 90 seconds ran out; the round was
  played to the end), `restart` (START OVER in the pause menu), `menu` (MENU
  in the pause menu, or the system back gesture mid-round), `background` (the
  app went to the background mid-round and the process never came back;
  parked by the package with the values at the time of the pause).
- `level` is the difficulty phase reached (`GameConfig.phases`: 0 from the
  start, 1 from 30 s, 2 from 60 s).

## Purchases

A purchase is the flow `purchase_start` / `purchase_end`: the player asked
for a pack (or the all-packs bundle) and the store sheet opened or could not
open. `ok` (bought), `cancel` (sheet dismissed), `error` (the store refused or
the sheet did not start), `unavailable` (the store has not answered: offline
or no products), `background` (the app went away during the purchase and
never came back). A purchase still waiting for approval (Ask to Buy) stays
open and ends with `background` or not at all.

## Activation

The first round played to the end on this install (`run_end` with
`result: death`). Once per install.

## Features

Used by `feature_snapshot` (3rd, 6th and 11th session) to tell which parts of
the game experienced players actually touch:

| Feature | When |
|---|---|
| `skins` | a different skin picked in the skins screen |
| `leaderboard` | the local leaderboard opened (menu or result screen) |
| `online_board` | Game Center / Play Games leaderboard asked for |
| `initials` | initials typed for a local top-20 score |
| `reload_swipe` | reloaded by swiping down |
| `reload_tap` | reloaded by tapping the ammo belt |
| `auto_reload` | automatic reload switched on |
| `sound_off` | sound switched off |
| `haptics_off` | vibration switched off |
| `restore` | Restore purchases tapped |

## Skins

Skin ids are the catalogue (`Skin.all`, generated `skin_catalog.dart`):
`vector`, `classic`, `flat_vector`, `watercolor`, `pixel16`, `storybook`, `crayon`, `lowpoly`, `clay`, `papercut`, `comic`, `anime`, `linocut`, `pixel8`, `handheld`, `cga`, `vector_crt`, `vga_dos`, `vhs`, `synthwave`, `airbrush`, `ascii`, `isopixel`, `ukiyoe`, `swirl`, `impression`, `cubism`, `popart`, `nouveau`, `deco`, `bauhaus`, `manuscript`, `egypt`, `kawaii`, `plush`, `amigurumi`, `sticker`, `candy`, `rubber`, `balloon`, `marshmallow`, `cottage`, `pastelgoth`, `origami`, `stainedglass`, `mosaic`, `porcelain`, `woodtoy`, `steampunk`, `chrome`, `crystal`, `knit`, `embroidery`, `neonsign`, `cyberpunk`, `lightgrid`, `blacklight`, `holo`, `aurora`, `constellation`, `biolum`, `lava`, `fireworks`, `christmas`, `halloween`, `easter`, `valentine`, `winter`, `autumn`, `sakura`, `summer`, `newyear`, `carnival`, `czech_folk`, `modrotisk`, `czech_anim`, `alebrije`, `dotpaint`, `dala`, `sumie`, `madhubani`, `persian`, `tapa`, `robot`, `astronaut`, `alien`, `dragon`, `phoenix`, `ghost`, `skeleton`, `zombie`, `knight`, `wizard`, `photo`, `naturalist`, `blueprint`, `tiltshift`, `bronze`, `marble`, `chalk`, `graffiti`, `charcoal`, `pencil`, `gold`, `diamond`, `royal`, `fabrege`, `pearl`, `jade`, `obsidian`, `rosegold`, `velvet`, `champagne`. Pack ids: `retro`, `art`, `cute`, `materials`, `neon`, `seasons`,
`world`, `fantasy`, `nature`, `luxe`, and `all` for the bundle. A skin or pack
added to the catalogue joins these lists with the release that adds it.

## Common properties

Sent with every event.

| Property | Type | Values |
|---|---|---|
| `app_version` | enum | the app version (`kAppVersion`, checked against `pubspec.yaml`) |
| `platform` | enum | `ios`, `android`, `macos`, `windows`, `linux`, `other` |
| `lang` | enum | the app's resolved language: `cs`, `de`, `en`, `es`, `fr`, `it`, `pl`, `sk` |
| `session_band` | band | session number: `1`, `2`, `3-5`, `6-10`, `11+` |
| `days_band` | band | days since measuring began: `0`, `1`, `2-6`, `7-29`, `30+`, `pre` (played before measuring began) |
| `first_session` | bool | the very first session of a new install |
| `tester` | bool | tester build (`--dart-define=TESTER=true` or `TESTER_UNLOCK=true`) |

## Events

Each event answers a question from the plan (`DevConventions`
`Prompts/04-PLAN-analytika.md` §1).

### `app_open`

Cold start, or a new session after more than 30 minutes in the background.
*New player: what happens after the first launch; do they come back.*

| Property | Type | Values |
|---|---|---|
| `start` | enum | `cold`, `resume` |
| `session_band_first` | bool | the first session of this install in its `session_band` |
| `days_band_first` | bool | the first session of this install in its `days_band` |
| `campaign` | campaign | optional; QR campaign of a new install, `^[a-z0-9-]{1,24}$` (not sent by Kačeny yet) |

### `screen_view`

A screen appeared. *First-session funnel; where players go.*

| Property | Type | Values |
|---|---|---|
| `screen` | enum | `menu`, `play`, `pause`, `result`, `skins`, `leaderboard`, `settings`, `other` |
| `prev` | enum | the previous screen, or `none` |

### `screen_leave`

A screen was left. *How long players stay on each screen.*

| Property | Type | Values |
|---|---|---|
| `screen` | enum | as in `screen_view` |
| `secs` | int | foreground seconds on the screen |
| `actions` | int | app events, feature uses and locked taps during the stay |

### `session_pause`

The app went to the background or is closing. Sent at once.
*When and where players stop; how much time a session takes.*

| Property | Type | Values |
|---|---|---|
| `active_secs` | int | foreground seconds in this session |
| `screen` | enum | the screen at the time, or `none` |
| `screen_secs` | int | foreground seconds on that screen |
| `runs` | int | rounds started since the app was launched |

### `activation`

The first round played to the end on this install. Once per install.
*New player: how fast they reach the first full round.*

| Property | Type | Values |
|---|---|---|
| `secs` | int | seconds since this session's `app_open` |

### `feature_use`

The first use of a feature in a session (see Features).
*Experienced player: what they use.*

| Property | Type | Values |
|---|---|---|
| `feature` | enum | `skins`, `leaderboard`, `online_board`, `initials`, `reload_swipe`, `reload_tap`, `auto_reload`, `sound_off`, `haptics_off`, `restore` |

### `feature_snapshot`

After `app_open` of the 3rd, 6th and 11th session: which features this
install has ever used. *Experienced player: what they never use.*

| Property | Type | Values |
|---|---|---|
| `f_skins` | bool | skin picked |
| `f_leaderboard` | bool | local leaderboard opened |
| `f_online_board` | bool | online leaderboard asked for |
| `f_initials` | bool | initials typed |
| `f_reload_swipe` | bool | reloaded by swipe |
| `f_reload_tap` | bool | reloaded by tap |
| `f_auto_reload` | bool | automatic reload switched on |
| `f_sound_off` | bool | sound switched off |
| `f_haptics_off` | bool | vibration switched off |
| `f_restore` | bool | restore tapped |
| `features_used` | int | how many of them |

### `error_shown`

The player saw an error message. *Experienced player: where they struggle.*

| Property | Type | Values |
|---|---|---|
| `kind` | enum | `store_unavailable` (the purchase sheet could not open), `purchase_failed` (the store reported a failed purchase) |
| `screen` | enum | the screen at the time, or `none` |

### `locked_tap`

A locked skin tapped (opens the offer of its pack). *Which paid packs
attract players.*

| Property | Type | Values |
|---|---|---|
| `target` | enum | the pack of the skin: `retro`, `art`, `cute`, `materials`, `neon`, `seasons`, `world`, `fantasy`, `nature`, `luxe` |

### `game_ready`

The game route has loaded its skin and started the first round.
*Load time: does a heavy skin make the start slow.*

| Property | Type | Values |
|---|---|---|
| `ms` | int | milliseconds from opening the game screen, up to 600000 |
| `art` | enum | `vector` (drawn), `picture` (one picture), `animated` (wing-beat frames) |

### `run_start`

A round begins. *Funnel from menu to play; which skins are played.*

| Property | Type | Values |
|---|---|---|
| `from` | enum | `menu` (PLAY), `result` (REPLAY), `pause` (START OVER) |
| `skin` | enum | the skin flown, see Skins |
| `auto_reload` | bool | automatic reload on |

### `run_end`

The round ends. *Where players struggle: how often they give up, how well
they shoot.*

| Property | Type | Values |
|---|---|---|
| `result` | enum | `death`, `restart`, `menu`, `background`; `ok`, `cancel`, `error` exist in every flow and are unused |
| `secs` | int | foreground seconds of the round |
| `level` | int | difficulty phase reached, `0`–`2` |
| `cause` | enum | what ended a `death`: `time` (the 90 seconds ran out); `none` otherwise |
| `score` | int | final score |
| `shots` | int | shots fired |
| `hits` | int | shots that hit |
| `streak` | int | best hit streak |

### `skin_pick`

A different skin chosen, by tap or after buying its pack. *Which skins
players like.*

| Property | Type | Values |
|---|---|---|
| `skin` | enum | see Skins |
| `free` | bool | from the free pack |

### `purchase_start`

The player asked for a pack. *Purchase funnel: which packs, from where.*

| Property | Type | Values |
|---|---|---|
| `pack` | enum | a paid pack or `all` (see Skins) |
| `from` | enum | `skin` (a locked skin's offer), `pack` (the pack header), `bundle` (the all-packs card) |

### `purchase_end`

The purchase ended. *Where purchases fail or are abandoned.*

| Property | Type | Values |
|---|---|---|
| `result` | enum | `ok`, `cancel`, `error`, `unavailable`, `background` |
| `secs` | int | foreground seconds from the request |
| `pack` | enum | as in `purchase_start` |

## Reading the data

`store-metrics report kaceny` on JODA (tester builds excluded). Useful cuts:

1. First-session funnel: `app_open` → `run_start` → `activation` → second
   session (`session_band_first` with band `2`).
2. Where sessions end: the last `session_pause` per session by `screen` and
   `active_secs`.
3. Rounds: `run_end` by `result` (how often a round is abandoned), median
   `score`, `hits`/`shots`, split by `session_band` and by `skin` of the
   matching `run_start`.
4. Skins: `skin_pick` and `run_start.skin` by skin; `locked_tap` →
   `purchase_start` → `purchase_end` by pack.
5. Feature adoption: `feature_snapshot` at the 6th and 11th session.
6. Load time: `game_ready.ms` p50/p90 by `art` and `platform`.

## Build and checking by hand

| `--dart-define` | Meaning |
|---|---|
| `TELEMETRY_KEY` | the app key at the receiver; empty → nothing is sent |
| `TELEMETRY_HOST` | the receiver, `https`; empty → nothing is sent |
| `TELEMETRY_DEBUG` | `true` prints events to the console instead of sending them |
| `TESTER` | `true` marks the build as a tester build |

The release workflows (`release-ios`, `release-android`) pass the key and
host from the GitHub secrets of the same names; an absent secret makes a
silent build. The key and the receiver address never go into this public
repository.

```bash
flutter run --profile --dart-define=TELEMETRY_DEBUG=true
```

prints one event per line; play one full round and compare with this file.
