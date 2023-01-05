json.cards @cards do |card|
  json.partial! 'shared/card_details', card: card
end
json.wallet @wallet

if @paypal_account.present?
  json.paypal_accounts @paypal_account do |account|
    user_name = User.find_by(id: account.user_id).name

    json.id account.id
    json.user_id account.user_id
    json.user_name user_name if user_name.present?
    json.payment_type account.payment_type
    json.is_default account.is_default
    json.account_id account.account_id
    json.account_type account.account_type
    json.email account.email
    json.created_at account.created_at
    json.updated_at account.updated_at
  end
else
  json.paypal_accounts []
end

