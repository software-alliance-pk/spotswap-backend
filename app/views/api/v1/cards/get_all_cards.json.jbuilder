json.cards @cards do |card|
  json.partial! 'shared/card_details', card: card
end
json.wallet @wallet
json.paypal_partner_account @paypal_account