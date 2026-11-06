"""Set up Kačeny in App Store Connect from the files in this repo.

    python3 tool/asc_store.py <step> [...]     steps: info listing rating price iap leaderboard shots all

Needs the App Manager API key (metadata and products; the "CI" developer key
gets 403): ~/Dev/Distribution/Apple/_Keys/AuthKey_$ASC_KEY_ID.p8, never
printed. The app record itself must exist (the API cannot create apps).
Every step is idempotent: existing records are updated, not duplicated.

- info:        name, subtitle, privacy URL per language; Games / Arcade
- listing:     description, keywords, promo text, support URL per language
- rating:      age rating questionnaire (cartoon violence, everything else none)
- price:       free app
- iap:         one non-consumable per paid pack at $0.99, names per language,
               review screenshot (store/iap-review.png)
- leaderboard: Game Center + the all-time leaderboard (kaceny.alltime)
- shots:       store/screenshots/<lang>/*.png as 6.9" iPhone screenshots
"""

import hashlib
import json
import os
import re
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

import jwt

ROOT = Path(__file__).resolve().parents[1]
BUNDLE = "com.ol1n.kaceny"
ISSUER = "edeaacd0-9ce8-4fae-91b7-e451efabc799"
KEY_ID = os.environ.get("ASC_KEY_ID", "YBT496SW43")
KEY = (Path.home() / f"Dev/Distribution/Apple/_Keys/AuthKey_{KEY_ID}.p8").read_text()
PRIVACY_URL = "https://olin.now/kaceny-privacy"
SUPPORT_URL = "https://olin.now/kaceny"
LISTING = json.loads((ROOT / "store/listing.json").read_text())
LANGS = [k for k in LISTING if not k.startswith("_")]
ASC_LOCALE = {lang: LISTING["_locales"][lang][0] for lang in LANGS}
PRIMARY = "en"

IAP_DESCRIPTION = {
    "en": "10 duck skins, each with its own background.",
    "cs": "10 skinů kachen, každý s vlastním pozadím.",
    "de": "10 Enten-Skins, jeder mit eigenem Hintergrund.",
    "pl": "10 skórek kaczek, każda z własnym tłem.",
    "sk": "10 skinov kačíc, každý s vlastným pozadím.",
    "es": "10 skins de patos, cada uno con su fondo.",
    "fr": "10 skins de canards, chacun avec son décor.",
    "it": "10 skin di anatre, ognuna con il suo sfondo.",
}
LEADERBOARD_NAME = {
    "en": "Best score", "cs": "Nejlepší skóre", "de": "Bestwert", "pl": "Najlepszy wynik",
    "sk": "Najlepšie skóre", "es": "Mejor puntuación", "fr": "Meilleur score", "it": "Miglior punteggio",
}


def _token():
    now = int(time.time())
    return jwt.encode({"iss": ISSUER, "iat": now, "exp": now + 1200, "aud": "appstoreconnect-v1"}, KEY,
                      algorithm="ES256", headers={"kid": KEY_ID})


def api(method, path, body=None, ok=(200, 201, 204)):
    url = path if path.startswith("http") else "https://api.appstoreconnect.apple.com" + path
    req = urllib.request.Request(url, data=json.dumps(body).encode() if body is not None else None, method=method,
                                 headers={"Authorization": "Bearer " + _token(), "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req) as r:
            raw = r.read()
            return json.loads(raw) if raw else {}
    except urllib.error.HTTPError as e:
        detail = e.read().decode()[:800]
        if e.code in ok:
            return {}
        raise SystemExit(f"{method} {path} -> {e.code}\n{detail}")


def get_all(path):
    out, url = [], path
    while url:
        r = api("GET", url)
        out += r.get("data", [])
        url = r.get("links", {}).get("next")
    return out


def rel(kind, id_):
    return {"data": {"type": kind, "id": id_}}


def upsert_localizations(existing, kind, parent_rel, values):
    """existing: list of localization records; values: {asc_locale: attrs}."""
    by_locale = {x["attributes"]["locale"]: x["id"] for x in existing}
    for locale, attrs in values.items():
        if locale in by_locale:
            api("PATCH", f"/v1/{kind}/{by_locale[locale]}",
                {"data": {"type": kind, "id": by_locale[locale], "attributes": attrs}})
        else:
            api("POST", f"/v1/{kind}", {"data": {"type": kind, "attributes": {"locale": locale, **attrs},
                                                 "relationships": parent_rel}})
        print(f"  {kind} {locale}")


def app_id():
    apps = api("GET", f"/v1/apps?filter[bundleId]={BUNDLE}")["data"]
    if not apps:
        raise SystemExit(f"No app with bundle id {BUNDLE} in App Store Connect yet: create it there first.")
    return apps[0]["id"]


def editable_app_info(app):
    infos = api("GET", f"/v1/apps/{app}/appInfos")["data"]
    live = ("READY_FOR_DISTRIBUTION", "READY_FOR_SALE")
    return next((i for i in infos if i["attributes"].get("appStoreState") not in live), infos[0])["id"]


def editable_version(app):
    versions = api("GET", f"/v1/apps/{app}/appStoreVersions?filter[platform]=IOS")["data"]
    for v in versions:
        if v["attributes"]["appStoreState"] in ("PREPARE_FOR_SUBMISSION", "DEVELOPER_REJECTED", "REJECTED",
                                                "METADATA_REJECTED", "INVALID_BINARY"):
            return v["id"]
    raise SystemExit("No editable App Store version (PREPARE_FOR_SUBMISSION).")


def step_info(app):
    info = editable_app_info(app)
    api("PATCH", f"/v1/appInfos/{info}", {"data": {"type": "appInfos", "id": info, "relationships": {
        "primaryCategory": rel("appCategories", "GAMES"),
        "primarySubcategoryOne": rel("appCategories", "GAMES_ARCADE"),
        "primarySubcategoryTwo": rel("appCategories", "GAMES_CASUAL"),
    }}})
    print("  category Games / Arcade, Casual")
    api("PATCH", f"/v1/apps/{app}", {"data": {"type": "apps", "id": app, "attributes": {
        "contentRightsDeclaration": "DOES_NOT_USE_THIRD_PARTY_CONTENT"}}})
    existing = get_all(f"/v1/appInfos/{info}/appInfoLocalizations")
    upsert_localizations(existing, "appInfoLocalizations", {"appInfo": rel("appInfos", info)}, {
        ASC_LOCALE[lang]: {"name": LISTING[lang]["name"], "subtitle": LISTING[lang]["subtitle"],
                           "privacyPolicyUrl": PRIVACY_URL}
        for lang in LANGS})


def step_listing(app):
    version = editable_version(app)
    existing = get_all(f"/v1/appStoreVersions/{version}/appStoreVersionLocalizations")
    upsert_localizations(existing, "appStoreVersionLocalizations",
                         {"appStoreVersion": rel("appStoreVersions", version)}, {
        ASC_LOCALE[lang]: {"description": LISTING[lang]["description"], "keywords": LISTING[lang]["keywords"],
                           "promotionalText": LISTING[lang]["promo"], "supportUrl": SUPPORT_URL,
                           "marketingUrl": SUPPORT_URL}
        for lang in LANGS})


def step_rating(app):
    info = editable_app_info(app)
    decl = api("GET", f"/v1/appInfos/{info}/ageRatingDeclaration")["data"]
    attrs = {}
    for k, v in decl["attributes"].items():
        if isinstance(v, bool):
            attrs[k] = False
        elif isinstance(v, str) or v is None:
            if k in ("kidsAgeBand", "ageRatingOverride", "ageRatingOverrideV2", "koreaAgeRatingOverride",
                     "developerAgeRatingInfoUrl"):
                continue
            attrs[k] = "NONE"
    # Ducks get shot and tumble out of the frame: cartoon, mild, frequent.
    attrs["violenceCartoonOrFantasy"] = "INFREQUENT_OR_MILD"
    api("PATCH", f"/v1/ageRatingDeclarations/{decl['id']}",
        {"data": {"type": "ageRatingDeclarations", "id": decl["id"], "attributes": attrs}})
    print("  age rating: cartoon violence infrequent/mild, everything else none")


def step_price(app):
    points = get_all(f"/v1/apps/{app}/appPricePoints?filter[territory]=USA&limit=200")
    free = next(p for p in points if float(p["attributes"]["customerPrice"]) == 0)
    api("POST", "/v1/appPriceSchedules", {
        "data": {"type": "appPriceSchedules", "relationships": {
            "app": rel("apps", app), "baseTerritory": rel("territories", "USA"),
            "manualPrices": {"data": [{"type": "appPrices", "id": "${free}"}]}}},
        "included": [{"type": "appPrices", "id": "${free}", "attributes": {"startDate": None},
                      "relationships": {"appPricePoint": rel("appPricePoints", free["id"])}}]})
    print("  price: free")


def _dart_map(name):
    src = (ROOT / "lib/l10n/skin_names.dart").read_text()
    block = src[src.index(f"const {name} ="):]
    block = block[:block.index("\n};") + 3]
    out, lang = {}, None
    for line in block.splitlines():
        m = re.match(r"\s*'(\w+)': \{", line)
        if m:
            lang = m.group(1)
            out[lang] = {}
        for k, v in re.findall(r"'(\w+)': '((?:[^'\\]|\\.)*)'", line):
            if lang:
                out[lang][k] = v.replace("\\'", "'")
    return out


def _paid_packs():
    catalog = (ROOT / "lib/game/skins/skin_catalog.dart").read_text()
    packs, cs = [], {}
    for pack, title, free in re.findall(r"packId: '(\w+)', packTitle: '([^']+)', free: (true|false)", catalog):
        if free == "false" and pack not in packs:
            packs.append(pack)
            cs[pack] = title
    return packs, cs


def _upload(create_path, kind, parent_rel, path):
    data = path.read_bytes()
    r = api("POST", create_path, {"data": {"type": kind, "attributes": {"fileName": path.name, "fileSize": len(data)},
                                           "relationships": parent_rel}})["data"]
    for op in r["attributes"]["uploadOperations"]:
        chunk = data[op["offset"]:op["offset"] + op["length"]]
        req = urllib.request.Request(op["url"], data=chunk, method=op["method"],
                                     headers={h["name"]: h["value"] for h in op["requestHeaders"]})
        urllib.request.urlopen(req).read()
    api("PATCH", f"/v1/{kind}/{r['id']}", {"data": {"type": kind, "id": r["id"], "attributes": {
        "uploaded": True, "sourceFileChecksum": hashlib.md5(data).hexdigest()}}})
    return r["id"]


def step_iap(app):
    packs, cs_titles = _paid_packs()
    names = _dart_map("packNames")
    existing = {x["attributes"]["productId"]: x["id"] for x in get_all(f"/v1/apps/{app}/inAppPurchasesV2?limit=200")}
    review_shot = ROOT / "store/iap-review.png"
    for pack in packs:
        product = f"{BUNDLE}.pack.{pack}"
        en = names["en"][pack]
        if product in existing:
            iap = existing[product]
        else:
            iap = api("POST", "/v2/inAppPurchases", {"data": {"type": "inAppPurchases", "attributes": {
                "name": f"Pack: {en}", "productId": product, "inAppPurchaseType": "NON_CONSUMABLE",
                "familySharable": True,
                "reviewNote": f"Unlocks the 10 skins of the '{en}' pack in the skin picker (menu > Skins). "
                              "Skins only change how the ducks and the background look."},
                "relationships": {"app": rel("apps", app)}}})["data"]["id"]
        print(f"  {product}")
        locs = get_all(f"/v2/inAppPurchases/{iap}/inAppPurchaseLocalizations")
        upsert_localizations(locs, "inAppPurchaseLocalizations", {"inAppPurchaseV2": rel("inAppPurchases", iap)}, {
            ASC_LOCALE[lang]: {"name": cs_titles[pack] if lang == "cs" else names[lang][pack],
                               "description": IAP_DESCRIPTION[lang]}
            for lang in LANGS})
        points = get_all(f"/v2/inAppPurchases/{iap}/pricePoints?filter[territory]=USA&limit=200")
        point = next(p for p in points if p["attributes"]["customerPrice"] == "0.99")
        api("POST", "/v1/inAppPurchasePriceSchedules", {
            "data": {"type": "inAppPurchasePriceSchedules", "relationships": {
                "inAppPurchase": rel("inAppPurchases", iap), "baseTerritory": rel("territories", "USA"),
                "manualPrices": {"data": [{"type": "inAppPurchasePrices", "id": "${p}"}]}}},
            "included": [{"type": "inAppPurchasePrices", "id": "${p}", "attributes": {"startDate": None},
                          "relationships": {"inAppPurchasePricePoint": rel("inAppPurchasePricePoints",
                                                                           point["id"])}}]})
        territories = [{"type": "territories", "id": t["id"]} for t in get_all("/v1/territories?limit=200")]
        api("POST", "/v1/inAppPurchaseAvailabilities", {"data": {
            "type": "inAppPurchaseAvailabilities", "attributes": {"availableInNewTerritories": True},
            "relationships": {"inAppPurchase": rel("inAppPurchases", iap),
                              "availableTerritories": {"data": territories}}}}, ok=(409,))
        if review_shot.exists():
            have = api("GET", f"/v2/inAppPurchases/{iap}/appStoreReviewScreenshot", ok=(404,)).get("data")
            if not have:
                _upload("/v1/inAppPurchaseAppStoreReviewScreenshots", "inAppPurchaseAppStoreReviewScreenshots",
                        {"inAppPurchaseV2": rel("inAppPurchases", iap)}, review_shot)
        print(f"    $0.99, all territories{', review screenshot' if review_shot.exists() else ''}")


def step_leaderboard(app):
    detail = api("GET", f"/v1/apps/{app}/gameCenterDetail", ok=(404,)).get("data")
    if not detail:
        detail = api("POST", "/v1/gameCenterDetails", {"data": {"type": "gameCenterDetails",
                                                                  "relationships": {"app": rel("apps", app)}}})["data"]
    boards = get_all(f"/v1/gameCenterDetails/{detail['id']}/gameCenterLeaderboards")
    board = next((b["id"] for b in boards if b["attributes"]["vendorIdentifier"] == "kaceny.alltime"), None)
    if not board:
        board = api("POST", "/v1/gameCenterLeaderboards", {"data": {"type": "gameCenterLeaderboards", "attributes": {
            "referenceName": "All-time best", "vendorIdentifier": "kaceny.alltime", "defaultFormatter": "INTEGER",
            "submissionType": "BEST_SCORE", "scoreSortType": "DESC"},
            "relationships": {"gameCenterDetail": rel("gameCenterDetails", detail["id"])}}})["data"]["id"]
    locs = get_all(f"/v1/gameCenterLeaderboards/{board}/localizations")
    upsert_localizations(locs, "gameCenterLeaderboardLocalizations",
                         {"gameCenterLeaderboard": rel("gameCenterLeaderboards", board)},
                         {ASC_LOCALE[lang]: {"name": LEADERBOARD_NAME[lang]} for lang in LANGS})


def step_shots(app):
    version = editable_version(app)
    for loc in get_all(f"/v1/appStoreVersions/{version}/appStoreVersionLocalizations"):
        locale = loc["attributes"]["locale"]
        lang = next((lang for lang in LANGS if ASC_LOCALE[lang] == locale), None)
        folder = ROOT / "store/screenshots" / (lang or "")
        if not lang or not folder.is_dir():
            continue
        sets = get_all(f"/v1/appStoreVersionLocalizations/{loc['id']}/appScreenshotSets")
        shot_set = next((s["id"] for s in sets if s["attributes"]["screenshotDisplayType"] == "APP_IPHONE_67"), None)
        if shot_set:
            for old in get_all(f"/v1/appScreenshotSets/{shot_set}/appScreenshots"):
                api("DELETE", f"/v1/appScreenshots/{old['id']}")
        else:
            shot_set = api("POST", "/v1/appScreenshotSets", {"data": {
                "type": "appScreenshotSets", "attributes": {"screenshotDisplayType": "APP_IPHONE_67"},
                "relationships": {"appStoreVersionLocalization": rel("appStoreVersionLocalizations",
                                                                     loc["id"])}}})["data"]["id"]
        files = sorted(folder.glob("*.png"))[:10]
        for f in files:
            _upload("/v1/appScreenshots", "appScreenshots", {"appScreenshotSet": rel("appScreenshotSets", shot_set)}, f)
        print(f"  {locale}: {len(files)} screenshots")


STEPS = {"info": step_info, "listing": step_listing, "rating": step_rating, "price": step_price,
         "iap": step_iap, "leaderboard": step_leaderboard, "shots": step_shots}

if __name__ == "__main__":
    wanted = sys.argv[1:] or ["all"]
    if wanted == ["all"]:
        wanted = list(STEPS)
    app = app_id()
    for name in wanted:
        print(name)
        STEPS[name](app)
