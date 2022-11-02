json.message do
  json.id @message.id
  json.body @message.body
  json.read_status @message.read_status
  json.user_id @message.user_id
  json.conversation_id @message.conversation_id
end