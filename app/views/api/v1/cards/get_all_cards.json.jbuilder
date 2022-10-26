json.cards @cards do |card|
  json.id card.id
  json.brand card.brand
  json.country card.country
  json.name card.name
  json.last_digit card.last_digit
  json.is_default card.is_default
  json.user_id card.user_id
end