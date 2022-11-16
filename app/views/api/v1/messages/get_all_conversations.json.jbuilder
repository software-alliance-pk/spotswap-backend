json.conversations @conversations do |conversation|
  json.id conversation.id
  json.sender_id conversation.sender.id
  json.sender_name conversation.sender_name
  json.recepient_id conversation.recepient.id
  json.recepient_name conversation.recepient_name
  json.sender_image conversation.sender_image&.attached? ? conversation.sender_image.url : ""
  json.recepient_image conversation.recepient_image&.attached? ? conversation.recepient_image.url : ""
  json.sender_last_message_body conversation.sender&.messages&.last&.body? ? conversation.sender.messages.last.body : ""
  json.is_blocked conversation.is_blocked
end