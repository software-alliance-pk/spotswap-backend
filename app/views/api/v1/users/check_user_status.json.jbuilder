json.user_status_detail do
  json.conversation_id @conversation.id
  json.sender_id @conversation.sender.id
  json.sender_status @conversation.sender.is_online
  json.recipient_id @conversation.recepient.id
  json.recipient_status @conversation.recepient.is_online
end