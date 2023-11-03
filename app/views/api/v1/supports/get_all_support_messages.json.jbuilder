json.support_messages @support_messages do |support_message|
  conversation = support_message.support_conversation
  json.id support_message.id
  json.body support_message.body
  json.support_conversation_id support_message.support_conversation_id
  json.read_status support_message.read_status
  json.sender_id support_message.sender_id
  json.sender_name conversation.sender_name
  json.recepient_id conversation.recipient_id
  json.recepient_name conversation.recipient_full_name
  json.type support_message.type? ? support_message.type : ""
  json.created_at support_message.created_at
  json.message_image support_message.image.attached? ? support_message.image.url : ""
  json.sender_image conversation.sender_image&.attached? ? conversation.sender_image.url : ""
  json.recepient_image conversation.recipient_image&.attached? ? conversation.recipient_image.url : ""
end