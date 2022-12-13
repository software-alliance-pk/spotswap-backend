json.default_payment do
  json.default_payment_id @default_payment.id
  json.payment_type @default_payment.payment_type
  json.user_id @default_payment.user_id
  json.card_detail @default_payment.card_detail
  json.stripe_card @card if @card.present?
end