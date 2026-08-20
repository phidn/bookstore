import { describe, expect, it } from 'vitest';
import { publicOrigin } from './origin';

describe('publicOrigin', () => {
  it('uses the request origin when a fresh deployment has no canonical origin', () => {
    expect(publicOrigin('https://new-store.example.workers.dev', undefined)).toBe(
      'https://new-store.example.workers.dev',
    );
  });

  it('uses and normalizes the configured HTTPS origin', () => {
    expect(publicOrigin('https://alternate.example', ' https://demo.bookstore.dev/ ')).toBe(
      'https://demo.bookstore.dev',
    );
  });

  it.each([
    '',
    'http://demo.bookstore.dev',
    'https://demo.bookstore.dev/store',
    'https://demo.bookstore.dev/?preview=1',
    'https://demo.bookstore.dev/#top',
    'https://user:pass@demo.bookstore.dev',
  ])('rejects an unsafe configured value: %j', (configured) => {
    expect(() => publicOrigin('https://fallback.example', configured)).toThrow(
      /CANONICAL_ORIGIN/,
    );
  });
});
