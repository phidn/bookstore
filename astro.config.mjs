import { defineConfig } from 'astro/config';
import cloudflare from '@astrojs/cloudflare';
import tailwindcss from '@tailwindcss/vite';
import { resolveTheme } from './scripts/themes.mjs';
import { themeCssPath, writeThemeArtifacts } from './scripts/theme-css.mjs';

import react from '@astrojs/react';

// SSR on Cloudflare Workers. platformProxy lets `astro dev` read bindings
// (D1, R2, vars) from wrangler.jsonc locally.
// Tailwind v4 is wired via its Vite plugin (the old @astrojs/tailwind
// integration is deprecated).

// Which theme this build compiles. Resolved once, here, and shared
// with Tailwind through the #theme-css alias below — the template alias
// and the CSS scope must never disagree, or the build succeeds while shipping
// an unstyled or wrongly styled site. The generated files are written for ALL
// themes and are byte-identical no matter which theme this process selected, so a
// concurrent build for another theme cannot fight a running dev server over
// them (see the design rule in scripts/theme-css.mjs).
const theme = resolveTheme();
writeThemeArtifacts();

// `astro check`/`astro build` and `astro dev` may run side by side during local
// work. If they share Vite's default cache directory, tooling can replace SSR files
// while the dev worker still references their previous hashes, causing random
// "file does not exist in deps_ssr" failures. Give diagnostics an isolated,
// disposable cache so it can never invalidate the live storefront.
const viteCacheDir = process.argv.includes('dev')
  ? 'node_modules/.vite-dev'
  : 'node_modules/.vite-tooling';

// Stamp every build with the theme it was compiled for. The deploy scripts
// refuse to ship an artifact whose stamp disagrees with the current
// selection — without this, `deploy --skip-build` happily deploys whatever
// design happened to be in dist/, and nothing ever knows.
const themeStamp = {
  name: 'bookstore:theme-stamp',
  hooks: {
    'astro:build:done': async () => {
      const { writeFileSync, mkdirSync } = await import('node:fs');
      mkdirSync(new URL('./dist', import.meta.url).pathname, { recursive: true });
      writeFileSync(
        new URL('./dist/theme.json', import.meta.url).pathname,
        `${JSON.stringify({ theme: theme.id }, null, 2)}\n`,
      );
    },
  },
};

export default defineConfig({
  output: 'server',
  integrations: [themeStamp, react()],
  // Replaced by the equivalent middleware guard so the bearer-capability
  // /pay/otk_… form can support clients that omit Origin without weakening
  // cookie-authenticated Admin/account forms.
  security: { checkOrigin: false },
  adapter: cloudflare({
    // Keep Cloudflare Images opt-in. The adapter otherwise auto-provisions an
    // IMAGES binding even though bookstore stores and serves originals from R2.
    imageService: 'passthrough',
    remoteBindings: process.env.REMOTE_BINDINGS === 'true' || process.env.USE_PROD_DATA === 'true' || process.env.PROD_API === 'true',
  }),
  vite: {
    cacheDir: viteCacheDir,
    plugins: [tailwindcss()],
    // The /pay route imports the Lightning QR renderer alongside demo checkout.
    // Keeping uqr out of Vite's SSR optimizer avoids stale hashed module paths
    // when another Astro command refreshes node_modules/.vite during local dev.
    optimizeDeps: {
      exclude: ['uqr'],
    },
    resolve: {
      alias: {
        '#theme': theme.dir,
        // The per-theme stylesheet this process compiles. Selection by alias is
        // the point: the files on disk never change per process, only which
        // one global.css's @import resolves to. Tailwind v4's plugin follows
        // Vite aliases in CSS @import (probed before relying on it).
        '#theme-css': themeCssPath(theme.id),
      },
    },
  },
});