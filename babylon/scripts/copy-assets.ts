// npm run assets (runs before dev/build): copies what the web uses from the Flutter app's assets/
// unchanged into public/assets/ (gitignored), so the web never keeps a second copy in git.
// F0 spike: vector skin only, nothing to copy yet. F3: audio + the free skin pack (paid packs are
// not on the web: in-app purchases are dropped, plan 06 §1).
import { rmSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const dst = fileURLToPath(new URL('../public/assets/', import.meta.url));
rmSync(dst, { recursive: true, force: true });
console.log('assets: vector skin only (F0), nothing copied');
