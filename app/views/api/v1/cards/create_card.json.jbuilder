json.card do
  json.partial! 'shared/card_details', card: @card
  json.stripe_card_response @stripe_card_response
end
