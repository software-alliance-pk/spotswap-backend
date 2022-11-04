json.cards @cards do |card|
  json.partial! 'shared/card_details', card: card
end