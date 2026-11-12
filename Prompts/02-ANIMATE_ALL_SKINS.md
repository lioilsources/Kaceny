# 02-ANIMATE_ALL_SKINS.md — handoff pro Claude Code (Opus)

## Cíl

Všech 112 generovaných skinů má mít kachnu, která mává křídly. Dnes mává 12 (dva v balíčku Základ, po jednom v každém placeném), zbylých 100 je jeden statický obrázek, který hra jen vodorovně mačká (`_spriteFlap` v `duck_component.dart`).

Výsledkem je PR s novými snímky, stránka, na které uživatel animace odsouhlasí, a zpráva o běhu. Nic se nemerguje, netaguje ani nevydává bez uživatele.

Mimo rozsah: vektorový skin „Původní“ (mává už teď) a velká kachna vykukující z hrany (kreslí ji `EdgeDuckPainter`, skiny ji nemění).

## Kde to běží

Uživatel určil GPU **L40S**. SPARK se pro tuhle úlohu nepoužívá vůbec: žádné `sparkctl`, žádné `comfyui.ol1n.com`.

Z `DevConventions/shared/infra.md` a `ports.md` (tam ověřeno 31. 10. 2026):

- Přístup `ssh tcloud`, porty tuneluje `tcloud-tunnel` (launchd). ComfyUI je podle `ports.md` na Macu na portu 8188 (`http://127.0.0.1:8188`).
- 46 GB VRAM, 8 vCPU, 23 GB RAM.
- Před během přečti `TMobileSandbox/tmobile-sandbox/MODEL_NOTES.md` a nová zjištění tam doplň.
- `~/tmobile-sandbox` na VM není git. Pokud tam něco spouštíš, nejdřív ten adresář `rsync`ni z Macu.
- Modely se stahují jen se souhlasem uživatele.

Co se při přípravě plánu ověřit nedalo (MacBook, kde plán vznikl, nemá `tcloud` v `~/.ssh/config` ani repo TMobileSandbox), a proto to patří do kroku 0:

- jestli ComfyUI na L40S má modely a uzly ze seznamu níže,
- s jakými přepínači ComfyUI běží a jestli VRAM zároveň nedrží vLLM nebo Whisper,
- jak rychlý je tam jeden klip.

## Co už existuje

Pipeline v `tool/skins/` je hotová a na 15 skinech vyzkoušená:

- `wan_flap.py`: ze zdrojové kachny (`tool/skins/out/duck/<id>.jpg`, 512 px, světle šedé pozadí, hlava dolů) udělá Wan 2.2 I2V 14B klip 33 snímků 512 × 512 (high/low-noise experti, 4krokové Seko LoRA). Snímky ukládá do `out/wan/<id>/f_NN.png`.
- `wan_frames.py`: vezme první mávnutí (6–16 snímků; konec cyklu je snímek nejpodobnější nultému), vyřízne pozadí přes RMBG-2.0, zarovná tělo podle osy (`body_axis`), ořízne jedním společným boxem a uloží `assets/skins/duck/<id>_N.png`. Pak přepíše `lib/game/skins/skin_catalog.dart`.
- Hra přehraje libovolný počet snímků; jedno mávnutí trvá 0,30–0,43 s.

Modely a uzly, které graf potřebuje: `wan2.2_i2v_high_noise_14B_fp8_scaled`, `wan2.2_i2v_low_noise_14B_fp8_scaled`, obě `Wan2.2-I2V-A14B-4steps-lora-rank64-Seko-V1_*`, `umt5_xxl_fp8_e4m3fn_scaled`, `wan_2.1_vae`, uzel `RMBG` s modelem RMBG-2.0.

Čísla z minulých běhů (na SPARKu): klip zhruba 70 s včetně načtení modelu, 12 z 15 skinů se povedlo. Synthwave, deco a naturalist vypadly: pták se otočil, odletěl ze záběru, nebo se skoro nehnul.

## Co je na tom těžké

**1. Pětina klipů se nepovede a nikdo je neprohlédne ručně.** Minule se vybíralo okem na 15 kusech. U 100 skinů a víc seedů to nejde, takže výběr musí být automatický a člověk kontroluje až výsledek. Tři známé vady mají každá svou míru:

- *skoro se nehnul*: rozpětí křídel (šířka masky) se během cyklu mění málo. Pozor, `cycle_length` tuhle vadu neodhalí, naopak: u nehybného ptáka je nultému snímku podobný kterýkoli.
- *otočil se nebo odletěl*: střed a délka těla z `body_axis` se během cyklu posouvají nebo se mění úhel osy.
- *smyčka nedosedne*: poslední snímek cyklu se od nultého liší víc než sousední snímky mezi sebou.

Masku pro skórování stačí udělat prahem proti šedému pozadí, RMBG je potřeba až pro vítězný klip. Prahy nastav podle 12 hotových skinů (dobré) a tří vyřazených klipů v `out/wan/` (špatné), pokud je na stroji máš.

**2. Víc seedů místo jednoho.** `wan_flap.py` dnes pouští jeden seed a hotový skin přeskočí. Potřebuje N seedů na skin, uložit seed ke klipu a umět dopustit další kolo jen pro skiny bez vyhovujícího klipu.

**3. Skripty dnes míří na SPARK a nosí s sebou jeho přihlašovací údaje.** `load_env` načte `Kiran/pipeline/.env`, kde je `COMFYUI_API_URL` i `CF_ACCESS_CLIENT_ID/SECRET`. Důsledky:

- bez přepsání `COMFYUI_API_URL` odejde celá dávka na SPARK,
- s přepsáním se Cloudflare Access hlavičky pošlou na L40S, kam nepatří.

Oprav to v kódu, ne jen v příkazu: hlavičky posílej jen na hosta `comfyui.ol1n.com` a běh pro tuhle úlohu ať skončí chybou, když cíl není localhost.

**4. Paměť na L40S.** Oba Wan experti mají kolem 14 GB, textový enkodér necelých 7 GB. Do 46 GB VRAM se vejdou najednou, do 23 GB RAM ne. Když ComfyUI mezi kroky odkládá modely do RAM, hrozí swap nebo pád. Ověř při pilotu (`free -h`, `nvidia-smi`) a případně navrhni uživateli spuštění s modely drženými ve VRAM. Restart nebo změnu konfigurace ComfyUI na VM nedělej bez jeho souhlasu.

**5. Velikost aplikace.** Snímek 256 px má jako PNG průměrně 27 KB. 100 skinů po zhruba 10 snímcích by přidalo kolem 27 MB k dnešním 22 MB skinů. Změřeno na stávajících 111 snímcích: PNG 3040 KB, WebP q85 852 KB. Doporučení:

- cyklus delší než 8 snímků převzorkuj rovnoměrně na 8 (mávnutí trvá nejvýš 0,43 s, víc snímků není vidět),
- snímky ukládej jako WebP a změň příponu v `Skin.duckFrameAssets` a v exportu; statický `<id>.png` pro výběr skinů nech být,
- na pixelových stylech (pixel8, pixel16, cga, handheld) zkontroluj, jestli ztrátový WebP nerozmazává hrany; když ano, ulož je bezztrátově.

Stávajících 12 skinů jen překóduj ze současných PNG, znovu je negeneruj. Uživatel je už schválil.

## Postup

**0. Příprava.**
- Zdrojové kachny `tool/skins/out/duck/*.jpg` jsou v `.gitignore` a existují jen na MacBooku. Pokud je na svém stroji nemáš, zastav se a řekni to uživateli; z `assets/skins/duck/<id>.png` (256 px výřez) je nerekonstruuj, kvalita by šla dolů.
- Ověř tunel (`curl http://127.0.0.1:8188/system_stats`), modely a uzly přes `/object_info`, volnou VRAM. Když něco chybí, vypiš co a zeptej se; nic nestahuj sám.
- Přečti `MODEL_NOTES.md`.
- Pracuj na větvi `feat/animate-all-skins`.

**1. Úpravy skriptů.** Ochrana cíle a hlaviček (bod 3), seedy a metadata klipu, skórování, mezisklad. `wan_frames.py` dnes maže staré snímky a zapisuje rovnou do `assets/`; nově ať výsledek jde nejdřív do `out/` a do `assets/` až po schválení.

**2. Pilot na 10 skinech.** Synthwave, deco a naturalist (minulé neúspěchy) a sedm stylů napříč: jeden pixelový, akvarel, plastelína nebo low-poly, ascii nebo vector_crt (čáry na černé), jeden neonový, jeden z balíčku Luxus, jeden z Přírody. Po třech seedech. Z pilotu má vypadnout:

- čas na klip na L40S a z něj odhad celé dávky,
- jestli prahy skórování sedí s tím, co vidíš na kontaktních listech,
- podíl skinů, které mají aspoň jeden vyhovující klip.

Když u minulých neúspěchů neprojde ani jeden ze tří seedů, zkus na nich jednu změnu receptu a porovnej stejnými mírami. Dvě rozumné možnosti: klip se stejným prvním a posledním snímkem (uzel `WanFirstLastFrameToVideo` se stejnými I2V modely; ověř v `/object_info`, že existuje), což vynutí dosednutí smyčky, nebo high-noise expert bez 4krokové LoRA s CFG nad 1, protože zrychlovací LoRA pohyb tlumí. Nezkoušej víc variant, než kolik rozhodne o dávce.

Výsledek pilotu pošli uživateli a počkej na souhlas s dávkou. Je to bod, kde se dá levně změnit směr.

**3. Dávka.** Zbylých 90 skinů, pro začátek dva seedy na skin, pak další kola jen pro ty bez vyhovujícího klipu, nejvýš pět seedů celkem. Běh musí jít přerušit a pustit znovu od místa, kde skončil. Při odhadu zhruba 70 s na klip je první kolo na několik hodin; pusť ho na pozadí a průběžně kontroluj, že fronta běží a VRAM nepřetéká.

**4. Výřez a export.** Jen vítězný klip každého skinu: RMBG, zarovnání, společný box, případné převzorkování na 8 snímků, kódování. Zkontroluj, že žádný snímek není po výřezu prázdný a že křídla nejsou oříznutá okrajem.

**5. Kontrola uživatelem.** Jedna stránka se všemi 112 skiny jako běžící animace v rychlosti hry, po balíčcích, s označením skinů, které prošly těsně nebo neprošly. U každého možnost označit „předělat“. Uživatel na takové výběry používá artefakty; viz `tool/skins/out/artifact.html` z výběru skinů. Označené skiny jdou do dalšího kola seedů.

**6. Aplikace.** Schválené snímky do `assets/skins/duck/`, přegenerovat `skin_catalog.dart`, `flutter analyze`, `flutter test --exclude-tags golden`. Pak pár skinů opravdu pusť ve hře v simulátoru (`tool/store_screenshots.sh` umí otevřít hru s daným skinem přes `shots.screen` a `settings.skin`) a podívej se, že kachna mává plynule, neposkakuje mezi snímky a sedí v zásahovém kruhu.

**7. PR a zpráva.**

## Hranice

- SPARK ne. Na L40S žádné stahování modelů, restart služeb ani změna konfigurace bez souhlasu uživatele.
- Zdrojové kachny ani pozadí negeneruj znovu. Mění se jen snímky křídel.
- Commit a push na větev ano, merge, tag a vydání ne.
- Env soubory nevypisuj.
- Neměň herní čísla (rychlost mávání, zásahové kruhy).

## Co s tím souvisí, ale rozhoduje uživatel

Až budou mávat všechny skiny, štítek „mává“ ve výběru skinů (`skinsAnimated`) přestane cokoli rozlišovat a text v obchodech říká „mnohé s mávajícími křídly“ (`store/listing.json`, 8 jazyků). Navrhni úpravu v PR popisu, ale neprováděj ji, dokud uživatel neřekne. Nové snímky se k hráčům dostanou až s další verzí aplikace.

## Hotovo znamená

- Každý ze 112 skinů má snímky mávání, nebo je jmenovitě uveden jako nedokončený s důvodem.
- Uživatel animace viděl na kontrolní stránce a odsouhlasil je.
- `flutter analyze` čistý, testy prochází, hra s novými snímky běží v simulátoru.
- Složka `assets/skins/duck` není výrazně větší než dnešních 7,6 MB; skutečné číslo je ve zprávě.
- Zjištění o L40S jsou doplněná v `MODEL_NOTES.md`.

## Co vrátit

- Odkaz na PR a na kontrolní stránku.
- Tabulku skin → seed, recept, délka cyklu, skóre, stav.
- Seznam skinů, které se nepovedly, a co se na nich zkoušelo.
- Čas na klip a celkový čas na L40S, velikost assetů před a po.
- Zvlášť označ, co jsi ověřil během, a co jen předpokládáš.
