"""Set up Kačeny's Google Play listing and products from the files in this repo.

    python3 tool/play_store.py <step> [...]     steps: listing shots bundle iap all
    AAB=path/to/app-release.aab python3 tool/play_store.py bundle

Uses the google-play-publisher service account from
~/Dev/Distribution/Android/_GoogleConsole/GooglePlay/ (never printed). The app
must exist in Play Console with that account invited (Users and permissions),
and products need a payments profile and an uploaded build with the billing
permission.

- listing: title, short and full description per language, contact details
- shots:   store/screenshots/<lang>/ + common/ as phone screenshots, plus
           store/play-feature.png (1024x500) and the 512 px icon
- iap:     one managed product per paid pack at $0.99, the all-packs bundle
           at $4.99, names per language
"""

import json
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

import jwt

sys.path.insert(0, str(Path(__file__).resolve().parent))
from asc_store import ALL_DESCRIPTION, ALL_NAME, IAP_DESCRIPTION, LANGS, LISTING, ROOT, _dart_map, _paid_packs, shots_for  # noqa: E402

PACKAGE = "com.ol1n.kaceny"
SA_DIR = Path.home() / "Dev/Distribution/Android/_GoogleConsole/GooglePlay"
SA = json.loads(next(SA_DIR.glob("*.json")).read_text())
# Languages Play has no listing for (Odia, Punjabi) have null and are skipped.
PLAY_LOCALE = {lang: LISTING["_locales"][lang][1] for lang in LANGS}
PLAY_LANGS = [lang for lang in LANGS if PLAY_LOCALE[lang]]
PLAY_COPIES = LISTING.get("_playCopies", {})


def play_locales(lang):
    return [PLAY_LOCALE[lang], *PLAY_COPIES.get(lang, [])]
API = "https://androidpublisher.googleapis.com/androidpublisher/v3/applications/" + PACKAGE
UPLOAD = "https://androidpublisher.googleapis.com/upload/androidpublisher/v3/applications/" + PACKAGE
_token = None


def token():
    global _token
    if not _token:
        now = int(time.time())
        assertion = jwt.encode({"iss": SA["client_email"], "scope": "https://www.googleapis.com/auth/androidpublisher",
                                "aud": "https://oauth2.googleapis.com/token", "iat": now, "exp": now + 3600},
                               SA["private_key"], algorithm="RS256")
        body = urllib.parse.urlencode({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                                       "assertion": assertion}).encode()
        _token = json.load(urllib.request.urlopen("https://oauth2.googleapis.com/token", body))["access_token"]
    return _token


def api(method, url, body=None, raw=None, ctype="application/json", ok=()):
    data = raw if raw is not None else (json.dumps(body).encode() if body is not None else None)
    req = urllib.request.Request(url, data=data, method=method,
                                 headers={"Authorization": "Bearer " + token(), "Content-Type": ctype})
    try:
        with urllib.request.urlopen(req) as r:
            text = r.read()
            return json.loads(text) if text else {}
    except urllib.error.HTTPError as e:
        if e.code in ok:
            return None
        raise SystemExit(f"{method} {url} -> {e.code}\n{e.read().decode()[:800]}")


class Edit:
    """A Play edit: everything inside is applied at once on commit."""

    def __enter__(self):
        self.id = api("POST", f"{API}/edits", {})["id"]
        self.base = f"{API}/edits/{self.id}"
        return self

    def __exit__(self, kind, *_):
        if kind is None:
            api("POST", f"{self.base}:commit")
            print("  committed")
        else:
            api("DELETE", self.base, ok=(404,))


def step_listing():
    with Edit() as edit:
        api("PATCH", f"{edit.base}/details", {"defaultLanguage": PLAY_LOCALE["en"],
                                              "contactWebsite": "https://lioilsources.github.io/Kaceny/",
                                              "contactEmail": "business@olin.now"})
        for lang in PLAY_LANGS:
            entry = LISTING[lang]
            for locale in play_locales(lang):
                api("PUT", f"{edit.base}/listings/{locale}", {
                    "language": locale, "title": entry["name"],
                    "shortDescription": entry["playShort"], "fullDescription": entry["description"]})
                print(f"  listing {locale}")


def _replace_images(edit, locale, kind, files):
    api("DELETE", f"{edit.base}/listings/{locale}/{kind}")
    for f in files:
        api("POST", f"{UPLOAD}/edits/{edit.id}/listings/{locale}/{kind}?uploadType=media", raw=f.read_bytes(),
            ctype="image/png" if f.suffix == ".png" else "image/jpeg")


def step_shots():
    icon = ROOT / "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png"
    feature = ROOT / "store/play-feature.png"
    with Edit() as edit:
        for lang in PLAY_LANGS:
            for locale in play_locales(lang):
                if (ROOT / "store/screenshots" / lang).is_dir():
                    shots = shots_for(lang)[:8]
                    _replace_images(edit, locale, "phoneScreenshots", shots)
                    print(f"  {locale}: {len(shots)} screenshots")
                if feature.exists():
                    _replace_images(edit, locale, "featureGraphic", [feature])
        icon512 = ROOT / "store/play-icon.png"
        if icon512.exists():
            _replace_images(edit, PLAY_LOCALE["en"], "icon", [icon512])
        elif icon.exists():
            print("  (store/play-icon.png missing: upload a 512 px icon)")


def step_bundle(aab=None):
    """Upload an AAB (path in $AAB, default the v-tag release download) and
    put it on the production track as a draft release."""
    import os
    path = Path(aab or os.environ["AAB"])
    with Edit() as edit:
        bundle = api("POST", f"{UPLOAD}/edits/{edit.id}/bundles?uploadType=media", raw=path.read_bytes(),
                     ctype="application/octet-stream")
        code = bundle["versionCode"]
        api("PUT", f"{edit.base}/tracks/production", {"track": "production", "releases": [
            {"versionCodes": [str(code)], "status": "draft"}]})
        print(f"  bundle versionCode {code} -> production (draft)")


def step_iap():
    """One-time products (the legacy inappproducts API is closed): a US price,
    converted by Google for every other region, then activated."""
    packs, cs_titles = _paid_packs()
    names = _dart_map("packNames")
    items = [(pack, {lang: cs_titles[pack] if lang == "cs" else names[lang][pack] for lang in PLAY_LANGS},
              IAP_DESCRIPTION, 0) for pack in packs]
    items.append(("all", ALL_NAME, ALL_DESCRIPTION, 4))
    for pack, titles, descriptions, dollars in items:
        usd = {"currencyCode": "USD", "units": str(dollars), "nanos": 990000000}
        conversion = api("POST", f"{API}/pricing:convertRegionPrices", {"price": usd})
        converted, regions_version = conversion["convertedRegionPrices"], conversion["regionVersion"]["version"]
        regions = [{"regionCode": code, "price": p["price"], "availability": "AVAILABLE"}
                   for code, p in sorted(converted.items())]
        sku = f"{PACKAGE}.pack.{pack}"
        product = {"packageName": PACKAGE, "productId": sku,
                   "listings": [{"languageCode": locale, "title": titles[lang], "description": descriptions[lang]}
                                for lang in PLAY_LANGS for locale in play_locales(lang)],
                   "purchaseOptions": [{"purchaseOptionId": "buy", "buyOption": {"legacyCompatible": True},
                                        "regionalPricingAndAvailabilityConfigs": regions}]}
        api("PATCH", f"{API}/onetimeproducts/{sku}?allowMissing=true&updateMask=listings,purchaseOptions"
                     f"&regionsVersion.version={regions_version}", product)
        api("POST", f"{API}/oneTimeProducts/{sku}/purchaseOptions:batchUpdateStates", {"requests": [
            {"activatePurchaseOptionRequest": {"packageName": PACKAGE, "productId": sku,
                                               "purchaseOptionId": "buy"}}]})
        print(f"  {sku} ${dollars}.99, {len(regions)} regions, active")


STEPS = {"listing": step_listing, "shots": step_shots, "bundle": step_bundle, "iap": step_iap}

if __name__ == "__main__":
    wanted = sys.argv[1:] or ["all"]
    for name in (list(STEPS) if wanted == ["all"] else wanted):
        print(name)
        STEPS[name]()
