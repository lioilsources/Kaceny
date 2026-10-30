# Kačeny — plán monetizace

## Princip

Hra je celá zdarma a bez reklam. Platí se jen za vzhled (skiny) a za nové typy cílů. Gameplay ani skóre se za peníze nekupují. Žebříčky v Game Center tak zůstávají férové a hra může do kategorie pro rodiny, bez pay-to-win.

## Struktura nabídky

| Vrstva | Obsah | Cena (Apple tier) | Typ IAP |
|---|---|---|---|
| Zdarma | 12 skinů (balíček Základ) + klasické kachny | 0 | — |
| Odemknutelné hraním | 1 skin z každého placeného balíčku za achievement (např. 1000 bodů, 50 headshotů, 7 dní v řadě) | 0 | — |
| Skin balíček | 10 skinů (kachna + pozadí + paleta UI) | 1,99 € | non-consumable |
| Sezónní balíček | Vánoce / Halloween / Velikonoce, prodej omezený na období, po skončení zůstává koupeným | 1,99 € | non-consumable |
| Balíček cílů | nový typ cíle s vlastní mechanikou (např. Netopýři: cik-cak, noční mód) + 5 skinů | 2,99 € | non-consumable |
| Vše navždy | všechny současné i budoucí skiny a cíle | 9,99 € (v akci 6,99 €) | non-consumable |
| Spropitné | „Kup kachnám chleba" — jen poděkování, odznak v menu | 0,99 / 2,99 / 4,99 € | consumable |

Počáteční katalog: 10 placených skin balíčků (Retro, Galerie umění, Roztomilé, Materiály, Neon, Svátky, Lidové umění, Fantasy, Příroda, Luxus), z toho Svátky lze rozdělit na sezónní minipacky.

## Proč takhle

- **Non-consumable a žádné předplatné:** u jednoduché arcade hry lidi předplatné odrazuje a review v App Store je u něj přísnější. Restore Purchases funguje zadarmo.
- **Balíčky místo jednotlivých skinů:** méně produktů v App Store Connect (11 místo 100+), vyšší průměrná útrata a jednodušší review screenshoty. Kiran prodává po jednom skinu, tady je balíček rozumnější kompromis, protože skinů je 10× víc.
- **1 skin z balíčku zdarma za hraní:** hráč si skin vyzkouší a zbytek balíčku pak chce dokoupit. Zároveň to dává důvod k retenci.
- **Bez reklam:** hra je krátká session (1–3 min), reklama po každé hře ničí zážitek a u dětí (cílovka) vyžaduje COPPA / Families režim. Pokud by bylo potřeba, jen dobrovolná rewarded reklama „zdvojnásob mince", nikdy interstitial.
- **Vše navždy:** kotva pro cenové vnímání. Vedle 9,99 € vypadá jeden balíček za 1,99 € jako maličkost a velcí fanoušci koupí rovnou vše.

## Implementace

- Převzít `SkinStoreService` z Kiranu (`in_app_purchase`, cache v SharedPreferences, Restore). Místo `skinId → productId` použít `packId → productId` a `all_access`, který odemyká vše.
- `SkinRegistry`: každý skin = `{id, packId, duckSprite, background, uiTint}`. Zdarma = `packId == free` nebo odemčený achievementem.
- Product ID: `com.ol1n.kaceny.pack.<packId>`, `com.ol1n.kaceny.targets.<targetId>`, `com.ol1n.kaceny.all_access`, `com.ol1n.kaceny.tip.small|medium|large`.
- Výběr skinů: mřížka náhledů (kachna na pozadí), zámek s lokalizovanou cenou, tlačítko „Vyzkoušet" spustí 30s ukázkovou hru se skinem a pak nabídne koupi.
- Assety placených balíčků nejdřív přibalit do appky (~1–2 MB/skin v JPG/WebP). Při 100+ skinech pak přejít na On-Demand Resources / stahování z CDN.

## Kalendář obsahu

| Měsíc | Novinka |
|---|---|
| Launch | Základ (12 zdarma) + 4 balíčky (Retro, Roztomilé, Neon, Příroda) + Vše navždy |
| +1 | Balíček cílů Netopýři (noční mód) |
| +2 | Halloween (říjen), Galerie umění |
| +3 | Vánoce (prosinec) + cíl Dárky (chytání místo střílení) |
| dále | 1 balíček měsíčně, sezónní eventy, cíle podle oblíbenosti z analytiky |

## Metriky

- Konverze na první nákup (cíl 2–4 % hráčů), ARPPU, podíl Vše navždy vs. jednotlivé balíčky.
- Které skiny se nejvíc zkoušejí v ukázce a nekupují: chybí jim cena nebo kvalita?
- Retence D1/D7 před a po zavedení odemykání hraním.

## Rizika

- **App Review:** dětská kategorie znamená bez externích odkazů a bez sledování. Nákupy jsou za parental gate (jednoduchý příklad „kolik je 7 × 8").
- **Kvalita assetů:** AI skiny musí projít kurátorskou stránkou (`tool/skins/out/index.html`), ven jde jen to, co obstojí. Lepší 50 dobrých než 110 průměrných.
- **Copyright:** styly popisují techniku (ukiyo-e, pixel art), nekopírují konkrétní hry ani postavy.
