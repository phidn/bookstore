import type { Order, OrderItem } from '../orders/db';

/**
 * Telegram owner-alert side-channel. Fires alongside the email owner-notification
 * so the store operator gets an instant ping in Telegram for every new order —
 * useful for COD/bank-transfer orders where there's no Stripe push.
 *
 * Intentionally thin: one HTTP call to sendMessage, no retry (the email outbox
 * is already the durable channel; Telegram is best-effort supplementary). A
 * failure here is logged but never surfaced to the customer or order pipeline.
 *
 * Config pulled from two D1 settings (never env vars, matching project style):
 *   telegram_chat_id   — numeric string, e.g. "-1004416195653"
 *   telegram_thread_id — numeric string thread/topic id; absent = no thread
 * The bot token is a Worker secret: TELEGRAM_BOT_TOKEN.
 */

export interface TelegramConfig {
  botToken: string;
  chatId: string;
  threadId?: string | null;
}

/** Format a compact new-order message for Telegram (plain text). */
function buildOrderMessage(
  order: Order,
  items: OrderItem[],
  storeName: string,
  adminUrl: string,
): string {
  const lines: string[] = [];
  lines.push(`📦 *Đơn mới — ${storeName}*`);
  lines.push(`Order: \`${order.public_id ?? `#${order.id}`}\``);

  const method = order.payment_method === 'cod'
    ? 'COD (tiền mặt)'
    : order.payment_method === 'bank_transfer'
      ? 'Chuyển khoản'
      : order.payment_method;
  lines.push(`Thanh toán: ${method}`);

  lines.push('');
  for (const item of items) {
    lines.push(`• ${item.name} × ${item.quantity}`);
  }

  // Format total — VND has no decimal places
  const currency = order.currency?.toUpperCase() ?? 'VND';
  const total = currency === 'VND'
    ? `${order.amount_total_cents.toLocaleString('vi-VN')}đ`
    : `${(order.amount_total_cents / 100).toFixed(2)} ${currency}`;
  lines.push('');
  lines.push(`*Tổng: ${total}*`);

  if (order.email) {
    lines.push(`Email: ${order.email}`);
  }

  lines.push('');
  lines.push(`[→ Xem đơn hàng](${adminUrl})`);

  return lines.join('\n');
}

/**
 * Fire a Telegram message for a new order. Best-effort — never throws, logs
 * the error and returns false on failure so the caller can note it.
 */
export async function sendTelegramOrderAlert(
  config: TelegramConfig,
  order: Order,
  items: OrderItem[],
  storeName: string,
  origin: string,
): Promise<boolean> {
  try {
    const adminUrl = `${origin}/admin/orders/${order.public_id ?? order.id}`;
    const text = buildOrderMessage(order, items, storeName, adminUrl);

    const body: Record<string, unknown> = {
      chat_id: config.chatId,
      text,
      parse_mode: 'Markdown',
      disable_web_page_preview: true,
    };
    if (config.threadId) {
      body.message_thread_id = Number(config.threadId);
    }

    const res = await fetch(
      `https://api.telegram.org/bot${config.botToken}/sendMessage`,
      {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify(body),
      },
    );

    if (!res.ok) {
      const err = await res.text().catch(() => '');
      console.error(`Telegram alert failed (HTTP ${res.status}): ${err}`);
      return false;
    }
    return true;
  } catch (err) {
    console.error('Telegram alert error:', err instanceof Error ? err.message : String(err));
    return false;
  }
}
