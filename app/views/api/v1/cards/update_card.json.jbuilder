json.card do
  json.id @card.id
  json.name @card.name
  json.brand @card.brand
  json.country @card.country
  json.address @card.address
  json.last_digit @card.last_digit
  json.card_number @card.card_number
  json.cvc @card.cvc
  json.exp_month @card.exp_month
  json.exp_year @card.exp_year
  json.is_default @card.is_default
  json.user_id @card.user_id
end