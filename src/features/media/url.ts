/**
 * Public URL for a stored object. The single place that knows how a media key
 * becomes a URL, so products, pages, and branding cannot drift apart.
 *
 * With `baseUrl` set (config.images.baseUrl, from IMAGE_BASE_URL — e.g. an R2
 * custom domain) it returns an absolute URL that bypasses the Worker's /images
 * route; otherwise a root-relative `/images/...` path.
 */
export function mediaUrl(imageKey: string, baseUrl = ''): string {
  if (!imageKey) return '/placeholder.png?v=2';
  if (
    imageKey.startsWith('http://') ||
    imageKey.startsWith('https://')
  ) {
    return imageKey;
  }
  if (imageKey.startsWith('/')) {
    return `${imageKey}?v=2`;
  }
  return baseUrl ? `${baseUrl}/${imageKey}` : `/images/${imageKey}`;
}
