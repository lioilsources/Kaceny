# Kačeny v prohlížeči (Babylon.js)

Webová verze hry: <https://lioilsources.github.io/Kaceny/play/>.
Je to port Flutter aplikace (kořen repa) do TypeScriptu nad Babylon.js 9 (WebGL2). Kód je v `babylon/`,
mapa portu, paritní úrovně a odchylky jsou v [`babylon/PORT.md`](https://github.com/lioilsources/Kaceny/blob/master/babylon/PORT.md).

## Spuštění

```bash
cd babylon
npm ci
npm run dev      # http://localhost:5173
npm run gate     # lint + testy + build, totéž běží v CI
```

Deep linky: `?debug` FPS, `?seed=<n>` opakovatelné kolo. Ovládání: dotyk nebo myš (výstřel na stisk), přebití tahem dolů, ťuknutím na pás nábojů nebo klávesou R / mezerník.

## Vrstvy

| Složka | Obsah |
|---|---|
| `src/rules/` | čistá pravidla, bez Babylonu a DOM, hlídá ESLint |
| `src/game/` | Babylon scéna, herní smyčka, přepínání obrazovek |
| `src/ui/` | DOM a Canvas 2D |

## Jedna pravda: Flutter

- `npm run assets` (před `dev` a `build`) kopíruje `assets/` do `public/assets/` (nejsou v gitu).
- Zlaté vektory: `dart run tool/dump_vectors.dart` (z kořene repa) zapíše výstupy Dart pravidel do
  `babylon/test/golden/` a Vitest je přehraje. CI job `golden` je přegeneruje a porovná.
  Kdo změní pravidla v Dartu, spustí nástroj a commitne vektory.

## Nasazení

Workflow `.github/workflows/web.yml`: při push do `master` postaví `babylon/`, zkopíruje `docs/` do kořene a hru
pod `/play/` a nasadí na GitHub Pages (zdroj Pages = GitHub Actions). Na olin.now vede na hru pole `play:`
v `apps/kaceny/meta.md` (tlačítko „Hrát v prohlížeči“).
