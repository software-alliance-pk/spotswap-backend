json.card do
  json.id @card.id
  json.name @card.name
  json.brand @card.brand
  json.country @card.country
  json.address @card.address
  json.last_digit @card.last_digit
  json.is_default @card.is_default
  json.user_id @card.user_id
end