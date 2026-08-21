import type { APIRoute } from 'astro';
import { COVERS_BASE64 } from '../../features/catalog/coversData';

export const prerender = false;

const IMMUTABLE = 'public, max-age=31536000, immutable';

function base64ToUint8Array(base64: string): Uint8Array {
  const binaryString = atob(base64);
  const bytes = new Uint8Array(binaryString.length);
  for (let i = 0; i < binaryString.length; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }
  return bytes;
}

export const GET: APIRoute = async ({ params, url }) => {
  let fileName = params.file;
  if (!fileName) return new Response('Not found', { status: 404 });
  fileName = fileName.split('?')[0];

  const b64 = COVERS_BASE64[fileName];
  if (b64) {
    const bytes = base64ToUint8Array(b64);
    const mime = fileName.endsWith('.png')
      ? 'image/png'
      : fileName.endsWith('.svg')
        ? 'image/svg+xml'
        : 'image/jpeg';
    return new Response(bytes, {
      headers: {
        'content-type': mime,
        'cache-control': IMMUTABLE,
      },
    });
  }

  return new Response('Not found', { status: 404 });
};
