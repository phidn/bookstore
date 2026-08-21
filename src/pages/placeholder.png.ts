import type { APIRoute } from 'astro';
import { PLACEHOLDER_BASE64 } from '../features/catalog/coversData';

export const prerender = false;

function base64ToUint8Array(base64: string): Uint8Array {
  const binaryString = atob(base64);
  const bytes = new Uint8Array(binaryString.length);
  for (let i = 0; i < binaryString.length; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }
  return bytes;
}

export const GET: APIRoute = async () => {
  if (PLACEHOLDER_BASE64) {
    const bytes = base64ToUint8Array(PLACEHOLDER_BASE64);
    return new Response(bytes, {
      headers: {
        'content-type': 'image/png',
        'cache-control': 'public, max-age=31536000, immutable',
      },
    });
  }
  return new Response('Not found', { status: 404 });
};
