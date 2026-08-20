#!/usr/bin/env node
/**
 * Image Environment Tag Utility
 *
 * Demonstrates and inspects image rendering and environment tagging rules:
 * - Production: Clean, un-badged original images
 * - Staging / Demo: Tagged with [STAGING] or [DEMO] badge overlay
 * - Local: Tagged with [LOCAL] badge overlay
 *
 * Usage:
 *   node scripts/render-image-tag.mjs [--env=staging|production|local]
 */

const envArg = process.argv.find((a) => a.startsWith('--env='))?.split('=')[1] || process.env.ENVIRONMENT || 'staging';

console.log(`\n🖼️  Image Rendering Environment Tag Check:`);
console.log(`------------------------------------------`);
console.log(`Current Environment : ${envArg.toUpperCase()}`);

const tag = envArg === 'production' ? null : envArg === 'staging' ? 'STAGING' : envArg === 'demo' ? 'DEMO' : 'LOCAL';

if (tag) {
  console.log(`Image Status        : Tagged with badge [${tag}]`);
  console.log(`Badge Styling       : bg-black/75 text-amber-300 ring-1 ring-amber-400/30 font-bold uppercase`);
  console.log(`API Data Source     : ${envArg === 'staging' ? 'Staging / Demo Data' : 'Local SQLite DB'}`);
} else {
  console.log(`Image Status        : Clean (Production Original, No Badge)`);
  console.log(`API Data Source     : Cloudflare Production Remote DB`);
}
console.log(`------------------------------------------\n`);
