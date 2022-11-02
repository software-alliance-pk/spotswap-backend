json.conversations @conversations do |conversation|
  json.id conversation.id
  json.sender_id conversation.sender_id
  json.recepient_id conversation.recepient_id
  json.is_blocked conversation.is_blocked
end