"""Skin catalog for the Kačeny curation sheet.

Every style yields one duck sprite and one portrait background in the same
look, so a kept style is a ready skin. Styles are grouped into packs; the
`free` pack ships unlocked, the rest are paid packs (see Prompts/01-MONETIZATION.md).
"""

# Default background scenes, rotated over styles that don't name their own.
SCENES = [
    "a calm pond with reeds in the foreground, distant hills, wide open sky",
    "a marshland at golden hour, tall grass, a wide sky with soft clouds",
    "a misty lake at dawn, pine forest on the far shore, big pale sky",
    "a river valley with meadows and a forest, wide blue sky",
    "a mountain lake with rocky shore, huge sky with puffy clouds",
    "wetlands at sunset, silhouetted reeds, glowing orange sky",
    "a quiet lake at night under a big moon, starry sky",
    "a village pond with a wooden jetty and willows, open sky",
]

# pack id -> (title, price tier, [(style id, name, style prompt, scene or None)])
PACKS = {
    "free": ("Základ (zdarma)", "free", [
        ("classic", "Klasika", "classic saturday-morning cartoon, bold black outlines, bright flat colors", None),
        ("flat_vector", "Flat vektor", "flat vector illustration, minimal geometric shapes, no outlines, modern", None),
        ("watercolor", "Akvarel", "soft watercolor painting, visible paper texture, gentle washes of color", None),
        ("pixel16", "Pixel 16-bit", "16-bit pixel art, limited palette, crisp hard pixels, retro console sprite", None),
        ("storybook", "Pohádková kniha", "children's storybook illustration, gouache, warm cozy colors", None),
        ("crayon", "Pastelky", "child's wax crayon drawing on white paper, scribbly texture", None),
        ("lowpoly", "Low-poly", "low-poly 3D render, faceted geometry, soft studio lighting", None),
        ("clay", "Plastelína", "claymation, plasticine with fingerprints, stop-motion look", None),
        ("papercut", "Vystřihovánka", "layered paper cut-out craft, soft drop shadows between layers", None),
        ("comic", "Komiks", "american comic book art, halftone dots, confident ink lines", None),
        ("anime", "Anime", "anime style, cel shading, clean thin lineart, vivid colors", None),
        ("linocut", "Linoryt", "linocut print, two colors, carved gouge texture", None),
    ]),
    "retro": ("Retro herna", "pack", [
        ("pixel8", "8-bit", "8-bit pixel art, 4-color palette, chunky pixels, NES-era sprite", None),
        ("handheld", "Zelený handheld", "monochrome pixel art in four shades of olive green, old handheld LCD", None),
        ("cga", "CGA", "pixel art in CGA palette, only cyan magenta black and white", None),
        ("vector_crt", "Vektorový monitor", "glowing green vector lines on pure black, oscilloscope wireframe", "a wireframe landscape of a lake and mountains"),
        ("vga_dos", "DOS VGA", "256-color VGA DOS game art, ordered dithering", None),
        ("vhs", "VHS", "1980s VHS tape still, chromatic aberration, scan lines, glitch", None),
        ("synthwave", "Synthwave", "80s synthwave, neon pink and purple, chrome highlights", "a neon grid lake under a striped retro sun"),
        ("airbrush", "Airbrush 80s", "1980s arcade cabinet airbrush art, glossy gradients", None),
        ("ascii", "ASCII", "ASCII art made of green monospace text characters on black", "a lake and hills drawn in monospace text characters"),
        ("isopixel", "Izometrický pixel", "isometric pixel art, clean pixel clusters", "an isometric pixel-art pond island with reeds"),
    ]),
    "art": ("Galerie umění", "pack", [
        ("ukiyoe", "Ukiyo-e", "Japanese ukiyo-e woodblock print, flat colors, wave patterns", None),
        ("swirl", "Vířivé tahy", "post-impressionist oil painting, thick swirling brush strokes", "a lake under a swirling starry night sky"),
        ("impression", "Impresionismus", "impressionist oil painting, dappled light, loose brushwork", "a water lily pond with a small bridge"),
        ("cubism", "Kubismus", "cubist painting, fragmented geometric planes, muted palette", None),
        ("popart", "Pop-art", "pop art, bold primary colors, Ben-Day dots, thick outlines", None),
        ("nouveau", "Secese", "art nouveau, flowing ornamental lines, muted gold and green", None),
        ("deco", "Art deco", "art deco 1920s poster, geometric gold and black", None),
        ("bauhaus", "Bauhaus", "bauhaus poster, primary colors, circles and rectangles", None),
        ("manuscript", "Iluminovaný rukopis", "medieval illuminated manuscript, gold leaf, vellum", None),
        ("egypt", "Egyptská malba", "ancient egyptian wall painting, ochre and lapis, flat profile", "the Nile with papyrus reeds and pyramids"),
    ]),
    "cute": ("Roztomilé", "pack", [
        ("kawaii", "Kawaii", "kawaii chibi, pastel colors, huge sparkly eyes, blush cheeks", None),
        ("plush", "Plyšák", "plush toy, soft felt fabric, visible stitched seams", None),
        ("amigurumi", "Háčkované", "crocheted amigurumi made of yarn, close-up", None),
        ("sticker", "Samolepka", "die-cut vinyl sticker, thick white border, glossy", None),
        ("candy", "Bonbóny", "made of candy and gummies, glossy sugar coating", "a lake of syrup with lollipop trees and candy hills"),
        ("rubber", "Gumová kachnička", "glossy yellow rubber bath toy, vinyl", "a bathtub full of water and foam bubbles"),
        ("balloon", "Balónek", "inflatable balloon animal, shiny latex", None),
        ("marshmallow", "Marshmallow", "squishy marshmallow 3D render, soft pastel", None),
        ("cottage", "Cottagecore", "cottagecore illustration, wildflowers, soft pastels", None),
        ("pastelgoth", "Pastel goth", "pastel goth, lilac and black, cute spooky", None),
    ]),
    "materials": ("Materiály", "pack", [
        ("origami", "Origami", "folded paper origami, crisp creases", None),
        ("stainedglass", "Vitráž", "stained glass window, lead lines, glowing colored glass", None),
        ("mosaic", "Mozaika", "roman tile mosaic, small stone tesserae", None),
        ("porcelain", "Porcelán", "blue and white painted porcelain, glossy glaze", None),
        ("woodtoy", "Dřevěná hračka", "carved and painted wooden toy, wood grain", None),
        ("steampunk", "Steampunk", "steampunk brass, gears, rivets, copper pipes", None),
        ("chrome", "Chrom", "polished liquid chrome, reflective", None),
        ("crystal", "Krystal", "faceted crystal glass, rainbow refractions", None),
        ("knit", "Pletené", "knitted wool, cozy sweater pattern", None),
        ("embroidery", "Výšivka", "embroidered patch, satin stitch threads", None),
    ]),
    "neon": ("Neon & noc", "pack", [
        ("neonsign", "Neonový nápis", "glowing neon tube sign", "a dark city rooftop lake with neon reflections"),
        ("cyberpunk", "Cyberpunk", "cyberpunk, magenta and cyan rim lighting, holograms", "a rainy cyberpunk canal under megacity towers"),
        ("lightgrid", "Světelná mřížka", "glowing cyan light lines on black, digital grid world", None),
        ("blacklight", "UV barvy", "fluorescent UV blacklight paint glowing in the dark", None),
        ("holo", "Hologram", "iridescent holographic foil, rainbow sheen", None),
        ("aurora", "Polární záře", "made of glowing northern lights ribbons", "a frozen lake under a huge aurora borealis"),
        ("constellation", "Souhvězdí", "constellation of stars connected by thin lines, star map", "a night sky full of constellations over a dark lake"),
        ("biolum", "Bioluminiscence", "deep sea bioluminescent glow, translucent", "a glowing bioluminescent lagoon at night"),
        ("lava", "Láva", "molten lava and glowing embers", "a volcanic lake of lava under an ash sky"),
        ("fireworks", "Ohňostroj", "made of sparkling firework trails", "a lake reflecting a sky full of fireworks"),
    ]),
    "seasons": ("Svátky a sezóny", "pack", [
        ("christmas", "Vánoce", "christmas, santa hat, festive red and green", "a snowy village pond with christmas lights"),
        ("halloween", "Halloween", "halloween, pumpkin orange and purple, spooky cute", "a foggy pond with jack-o-lanterns and a full moon"),
        ("easter", "Velikonoce", "easter, pastel painted egg patterns", "a spring meadow pond with painted eggs"),
        ("valentine", "Valentýn", "valentine, pink and red hearts", "a pond with heart shaped clouds"),
        ("winter", "Zima", "frosty ice, snowflakes, icy blue", "a frozen lake in a snowy forest"),
        ("autumn", "Podzim", "autumn, orange and brown falling leaves", "an autumn lake surrounded by colorful trees"),
        ("sakura", "Sakura", "cherry blossom spring, soft pink petals", "a pond under blooming cherry trees"),
        ("summer", "Léto", "summer beach, sunglasses, tropical colors", "a tropical lagoon with palm trees"),
        ("newyear", "Silvestr", "new year, gold confetti, party", "a city lake at midnight with gold confetti"),
        ("carnival", "Karneval", "venetian carnival mask, feathers, gold ornaments", "a venetian canal at dusk"),
    ]),
    "world": ("Lidové umění světa", "pack", [
        ("czech_folk", "Moravská výšivka", "czech moravian folk embroidery, red black and white floral ornaments", None),
        ("modrotisk", "Modrotisk", "czech indigo blueprint fabric, white resist-dye patterns on deep blue", None),
        ("czech_anim", "Český večerníček", "1960s czech hand-drawn cut-out animation, gentle textures", None),
        ("alebrije", "Alebrije", "mexican alebrije, vibrant patterned painted wood", None),
        ("dotpaint", "Tečkovaná malba", "dot painting, earthy ochre palette", None),
        ("dala", "Skandinávské", "scandinavian folk painting, red and blue, simple flowers", None),
        ("sumie", "Tuš", "chinese ink wash painting, sumi-e, sparse brush strokes", "misty mountains over a lake in ink wash"),
        ("madhubani", "Madhubani", "indian madhubani folk painting, intricate line patterns", None),
        ("persian", "Perská miniatura", "persian miniature painting, gold and turquoise, delicate detail", None),
        ("tapa", "Tapa", "polynesian tapa cloth, brown and black geometric patterns", None),
    ]),
    "fantasy": ("Fantasy & sci-fi", "pack", [
        ("robot", "Robot", "mechanical robot, rivets, glowing LED eyes", "a futuristic factory pond with pipes"),
        ("astronaut", "Kosmonaut", "astronaut in a space helmet", "a crater lake on an alien moon, earth in the sky"),
        ("alien", "Mimozemšťan", "alien creature, three eyes, purple skin", "an alien planet lake with two suns"),
        ("dragon", "Drak", "dragon hybrid, emerald scales, tiny horns", "a fantasy lake below a castle on a cliff"),
        ("phoenix", "Fénix", "fire phoenix, wings of flame", None),
        ("ghost", "Duch", "translucent friendly ghost, faint glow", "a haunted misty swamp at night"),
        ("skeleton", "Kostlivec", "x-ray skeleton, white bones on dark", None),
        ("zombie", "Zombie", "cute zombie, green skin, stitches", "a graveyard pond under a green moon"),
        ("knight", "Rytíř", "armored knight, shining steel plate armor", "a medieval moat around a castle"),
        ("wizard", "Čaroděj", "wizard, starry pointed hat, magic sparkles", "an enchanted lake with floating lights"),
    ]),
    "nature": ("Příroda a realismus", "pack", [
        ("photo", "Fotorealismus", "photorealistic mallard, wildlife photography, sharp detail", None),
        ("naturalist", "Přírodopisná tabule", "19th century naturalist hand-colored engraving plate", None),
        ("blueprint", "Technický výkres", "technical blueprint drawing, white lines on blue", "a blueprint plan of a pond and landscape"),
        ("tiltshift", "Mini figurka", "macro photo of a tiny toy figurine, tilt-shift blur", "a miniature diorama pond, tilt-shift"),
        ("bronze", "Bronz", "bronze statue with patina", None),
        ("marble", "Mramor", "white carved marble sculpture", None),
        ("chalk", "Křída", "chalk drawing on a blackboard", None),
        ("graffiti", "Graffiti", "graffiti street art, spray paint drips", "a concrete wall mural of a lake"),
        ("charcoal", "Uhel", "charcoal sketch, smudged, monochrome", None),
        ("pencil", "Tužka", "detailed graphite pencil sketch on cream paper", None),
    ]),
    "luxe": ("Luxus", "pack", [
        ("gold", "Zlato", "solid polished gold, luxury jewelry", None),
        ("diamond", "Diamant", "encrusted with diamonds, sparkling", None),
        ("royal", "Královská", "royal crown, purple velvet cape, gold trim", "a palace garden lake with fountains"),
        ("fabrege", "Smaltované vejce", "ornate enamel and gold filigree, jewelled egg style", None),
        ("pearl", "Perleť", "mother-of-pearl, opalescent shimmer", None),
        ("jade", "Nefrit", "carved green jade", None),
        ("obsidian", "Obsidián", "black obsidian with gold veins, kintsugi", None),
        ("rosegold", "Rose gold", "rose gold metal, soft pink sheen", None),
        ("velvet", "Samet", "plush velvet texture, deep jewel tones", None),
        ("champagne", "Šampaňské", "champagne bubbles and gold, art deco glamour", None),
    ]),
}

# 50+ things to shoot instead of ducks. (id, name, why it works, prompt subject)
TARGETS = [
    ("geese", "Husy", "větší a pomalejší, víc HP", "a flying goose"),
    ("pigeons", "Holubi", "městský level, hejna", "a flying city pigeon"),
    ("crows", "Vrány", "vrány kradou body", "a flying black crow"),
    ("seagulls", "Racci", "přímořský level, střemhlavé nálety", "a flying seagull"),
    ("bats", "Netopýři", "noční mód, cik-cak let", "a flying bat"),
    ("owls", "Sovy", "noční boss", "a flying owl"),
    ("parrots", "Papoušci", "barevná hejna, tropy", "a flying colorful parrot"),
    ("flamingos", "Plameňáci", "růžový skin pack", "a flying flamingo"),
    ("penguins", "Létající tučňáci", "absurdní humor", "a penguin with a jetpack"),
    ("chickens", "Slepice", "neumí létat — skáčou", "a flapping chicken"),
    ("bees", "Včely", "roje, malé rychlé cíle", "a flying bee"),
    ("butterflies", "Motýli", "mírumilovný mód — fotit místo střílet", "a butterfly"),
    ("dragonflies", "Vážky", "náhlé změny směru", "a dragonfly"),
    ("ladybugs", "Berušky", "pro nejmenší", "a flying ladybug"),
    ("mosquitoes", "Komáři", "plácání komárů, velmi malé cíle", "a mosquito"),
    ("fish", "Létající ryby", "podvodní level", "a flying fish"),
    ("jellyfish", "Medúzy", "pomalé vznášení, podmořský svět", "a jellyfish"),
    ("bubbles", "Bubliny", "praskání bublin, relax", "a soap bubble"),
    ("balloons", "Balónky", "pouťová střelnice", "a party balloon"),
    ("clay_pigeons", "Asfaltové terče", "klasická sportovní střelba", "a clay pigeon shooting disc"),
    ("bottles", "Lahve", "westernová střelnice", "a glass bottle"),
    ("cans", "Plechovky", "plechovky na plotě", "a tin can"),
    ("tin_ducks", "Plechové kachny", "pouťová střelnice — retro", "a tin fairground target duck"),
    ("pumpkins", "Dýně", "halloween event", "a flying jack-o-lantern"),
    ("snowballs", "Sněhové koule", "zimní event", "a snowball"),
    ("easter_eggs", "Kraslice", "velikonoční event", "a painted easter egg with wings"),
    ("presents", "Dárky", "vánoční event — chytat dárky", "a wrapped christmas present with wings"),
    ("ghosts", "Duchové", "halloween, průhlední", "a cute ghost"),
    ("zombies", "Zombie hlavy", "horror mód", "a cute cartoon zombie head"),
    ("aliens", "UFO", "sci-fi level", "a flying saucer UFO"),
    ("asteroids", "Asteroidy", "rozpadají se na menší", "an asteroid"),
    ("meteors", "Meteority", "hořící, rychlé", "a flaming meteor"),
    ("drones", "Drony", "moderní level", "a quadcopter drone"),
    ("robots", "Robotí ptáci", "kovové, víc zásahů", "a robot bird"),
    ("paper_planes", "Vlaštovky z papíru", "kancelářský level", "a paper airplane"),
    ("kites", "Draci (pouštění)", "podzimní level", "a kite"),
    ("leaves", "Listí", "podzimní relax", "a falling autumn leaf"),
    ("socks", "Ponožky", "lítající ponožky z pračky — humor", "a flying sock"),
    ("toast", "Toasty", "vyskakují z toustovače", "a slice of toast with wings"),
    ("pizza", "Pizza", "food pack", "a flying pizza slice"),
    ("donuts", "Donuty", "food pack", "a donut"),
    ("fruits", "Ovoce", "sekání ovoce, kombíčka", "a watermelon"),
    ("vegetables", "Zelenina", "děti vs. brokolice", "a broccoli with wings"),
    ("cookies", "Sušenky", "sladký pack", "a chocolate chip cookie"),
    ("dragons", "Dráčci", "fantasy boss", "a small cute dragon"),
    ("fairies", "Víly", "fantasy — nestřílet víly!", "a tiny fairy"),
    ("unicorns", "Jednorožci", "nestřílet — penalizace", "a flying unicorn"),
    ("witches", "Čarodějnice", "pálení čarodějnic event", "a witch on a broomstick"),
    ("santa", "Santa", "vánoční boss", "santa claus sleigh"),
    ("pterodactyls", "Pterodaktylové", "pravěký level", "a pterodactyl"),
    ("mammoths_balloons", "Létající ovce", "absurdní humor", "a sheep floating with balloons"),
    ("hats", "Klobouky", "vítr odfoukl klobouky", "a flying top hat"),
    ("emojis", "Emoji", "moderní, výrazy obličejů", "a yellow smiley face"),
    ("stars", "Hvězdy", "sbírat padající hvězdy", "a shooting star"),
    ("notes", "Noty", "rytmický mód — střílet do rytmu", "a flying music note"),
    ("letters", "Písmenka", "vzdělávací mód — sestav slovo", "a flying letter A block"),
    ("numbers", "Čísla", "vzdělávací mód — počítání", "a flying number 7 block"),
    ("coins", "Mince", "bonus level", "a gold coin with wings"),
]


def duck_prompt(style: str) -> str:
    return (
        f"a single duck flying, seen from directly above, wings spread wide, "
        f"head pointing down, {style}, centered, whole bird visible, "
        f"isolated on a plain flat light grey background, game sprite, no text"
    )


def bg_prompt(style: str, scene: str) -> str:
    return (
        f"vertical portrait mobile game background, {scene}, {style}, "
        f"the upper two thirds is open sky, no animals, no birds, no people, no text"
    )


def target_prompt(subject: str) -> str:
    return (
        f"{subject}, cute cartoon game sprite, bold outlines, bright colors, "
        f"centered, isolated on a plain flat light grey background, no text"
    )


def jobs():
    """Every image to generate: (kind, id, prompt, width, height, meta)."""
    out = []
    i = 0
    for pack_id, (pack_title, tier, styles) in PACKS.items():
        for sid, name, style, scene in styles:
            scene = scene or SCENES[i % len(SCENES)]
            i += 1
            meta = {"pack": pack_id, "pack_title": pack_title, "tier": tier, "name": name, "style": style}
            out.append(("duck", sid, duck_prompt(style), 1024, 1024, meta))
            out.append(("bg", sid, bg_prompt(style, scene), 768, 1344, {**meta, "scene": scene}))
    for tid, name, why, subject in TARGETS:
        out.append(("target", tid, target_prompt(subject), 768, 768, {"name": name, "why": why}))
    return out
