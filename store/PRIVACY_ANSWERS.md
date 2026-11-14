# Privacy answers for the build with anonymous statistics

Answers for App Store Connect (App Privacy) and Google Play Console (Data
safety) from the first Kačeny build that sends anonymous gameplay statistics
(`docs/telemetry.md`, `ol1n_telemetry`). They match
`ios/Runner/PrivacyInfo.xcprivacy` and `docs/privacy.html`.

Order: **policy → forms → key → release.** Fill them in only after the new
`docs/privacy.html` is live on GitHub Pages, and before a build with the
`TELEMETRY_KEY` secret is submitted. A build without the key sends nothing,
so the old answers (Data Not Collected) stay true for it. Check the current
wording of both forms before ticking; compare with what is declared today and
keep anything else already declared there.

What is sent, in one line: screens and seconds on them, round start and end
(skin, automatic reload, result, seconds, difficulty phase, score, shots,
hits, best streak), skin picks, taps on locked skins, pack purchase start and
end (pack, result; no payment details), store errors shown, first use of
features in a session, game load time in milliseconds, app version, platform,
language, session and day bands. No identifier, no text (leaderboard
initials are never sent), no device model. Received and stored by the
developer on its own server in the EU (Czech Republic); nobody else receives
it. The IP address is not stored; only the country is kept. Kept 12 months.
Switch: *Anonymous statistics* in Settings (deletes unsent records at once).

## App Store Connect → App Privacy

**Privacy Policy URL:** `https://lioilsources.github.io/Kaceny/privacy.html`,
unchanged.

**Do you or your third-party partners collect data from this app?** **Yes.**

| Category → type | Linked to the user? | Used for tracking? | Purpose |
|---|---|---|---|
| Usage Data → **Product Interaction** | **No** | **No** | **Analytics** |
| Diagnostics → **Performance Data** | **No** | **No** | **Analytics** |
| Location → **Coarse Location** | **No** | **No** | **Analytics** |
| Purchases → **Purchase History** | **No** | **No** | **Analytics** |

- *Product Interaction*: launches, screens, rounds, skin picks, locked skin
  taps, features used.
- *Performance Data*: game load time in milliseconds (`game_ready`).
- *Coarse Location*: the receiver keeps the country from the connection
  (Cloudflare country header), never the IP address. If the owner turns the
  country off for Kačeny at the receiver, untick this row and remove
  `NSPrivacyCollectedDataTypeCoarseLocation` from the privacy manifest.
- *Purchase History*: `purchase_start` / `purchase_end` say which pack was
  asked for and whether it was bought. Declared to be safe; it is anonymous
  and not linked. If the owner decides it is only product interaction, drop
  the row here and in the privacy manifest together.

Not collected (leave unticked): Contact Info, Health & Fitness, Financial
Info, Precise Location, Sensitive Info, Contacts, User Content, Browsing
History, Search History, Identifiers (no User ID and no Device ID: the
session id is random, lives in memory and is never reused), Other Usage
Data, Crash Data, Other Diagnostic Data, Other Data.

**Linked to the user: No** for every type: no account, no identifier; two
sessions cannot be connected to each other.

**Tracking: No.** Nothing is combined with other companies' data, nothing is
shared with data brokers, there is no advertising. No App Tracking
Transparency prompt (`NSPrivacyTracking` is `false`).

Payments are processed by Apple; the app never sees payment details. Game
Center scores are Apple's data under the player's Game Center account, not
collected by the app; not declared here (as before).

## Google Play Console → App content → Data safety

- Does your app collect or share any of the required user data types?
  **Yes.**
- Is all of the user data collected by your app encrypted in transit?
  **Yes** (the statistics client refuses a non-`https` receiver).
- Do you provide a way for users to request that their data is deleted?
  **No.** There is no account. The statistics carry no identifier, so no
  record can be found for a person; switching them off deletes the unsent
  ones on the device, and the server deletes them after 12 months. (Deletion
  requests are required only for apps with account creation.)

Data types, all **Collected**, **not shared** (the developer's own server, no
third party), **not processed ephemerally**, **optional** (*Anonymous
statistics* in Settings):

| Data type | Purpose |
|---|---|
| App activity → **App interactions** | **Analytics** |
| App info and performance → **Diagnostics** (game load time) | **Analytics** |
| Location → **Approximate location** (country only) | **Analytics** |
| Financial info → **Purchase history** (which pack was bought, anonymous) | **Analytics** |

If the country is turned off at the receiver, drop the *Approximate
location* row; drop *Purchase history* together with the App Store row if
the owner decides so.

Not collected: precise location, personal info, other financial info,
health, messages, photos and videos, audio, files, calendar, contacts, web
browsing, device or other IDs, crash logs. Play Billing and Play Games are
Google's services under the player's Google account.

**Advertising ID: No** (unchanged).

## Target audience (check before filling in)

`Prompts/01-MONETIZATION.md` names children as part of the audience. If the
Play Console target audience includes children under 13, the Families policy
applies and measuring on Android needs the owner's decision first (plan
§10.3, as for Lexify). The App Store build is not in the Kids category
(`tool/asc_store.py` leaves `kidsAgeBand` unset).

## Outside this repository

- App Store Connect → App Privacy: the table above.
- Google Play Console → Data safety: the table above.
- The Kačeny page on olin.now: wherever it says the game sends nothing,
  collects no data or has no analytics, say instead that it sends anonymous
  statistics that can be switched off (no ads, no account and no third-party
  analytics stay true), in every language of the page.
- The store descriptions in `store/listing.json` say "No ads, no account, no
  tracking. Plays offline." in all eight languages. That stays true (no
  tracking in the App Store sense, no third-party analytics) and is left as
  it is (plan §10.8, default choice); change it with the next metadata update
  if the owner wants to mention the statistics.
