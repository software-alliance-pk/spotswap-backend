json.cards @cards do |card|
  json.partial! 'shared/card_details', card: card
end
json.wallet @wallet

user_name = User.find_by(id: @paypal_account.user_id).name
json.paypal_account do
  json.id @paypal_account.id
  json.user_id @paypal_account.user_id
  json.user_name user_name if user_name.present?
  json.payment_type @paypal_account.payment_type
  json.is_default @paypal_account.is_default
  json.account_id @paypal_account.account_id
  json.account_type @paypal_account.account_type
  json.email @paypal_account.email
  json.created_at @paypal_account.created_at
  json.updated_at @paypal_account.updated_at
end
