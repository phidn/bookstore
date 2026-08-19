/** Store-specific checkout policy for Tiểu Viện Hữu Thư. */
export const localCommerce = {
  enabled: true,
  city: 'Hồ Chí Minh',
  country: 'VN',
  shippingLabel: 'Giao nội thành TP.HCM',
  shippingCents: 19_000,
  paymentMethods: ['cod', 'bank_transfer'] as const,
  bankTransfer: {
    bank: 'Techcombank',
    accountNumber: '19032752971013',
    accountName: 'DANG NHAT PHI',
    cardImage: '/bank-transfer-techcombank.png',
  },
};

export type LocalPaymentMethod = (typeof localCommerce.paymentMethods)[number];

export function isLocalPaymentMethod(value: unknown): value is LocalPaymentMethod {
  return value === 'cod' || value === 'bank_transfer';
}
