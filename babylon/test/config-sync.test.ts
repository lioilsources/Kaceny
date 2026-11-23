// Generated files must match their Dart source (plan 06: nothing is copied by hand).
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { expect, it } from 'vitest';
import { paletteSource, renderPalette } from '../scripts/gen-palette';

it('ui/generated/palette.ts matches lib/game/render/palette.dart (npm run gen)', () => {
  const committed = readFileSync(fileURLToPath(new URL('../src/ui/generated/palette.ts', import.meta.url)), 'utf8');
  expect(committed).toBe(renderPalette(paletteSource()));
});
