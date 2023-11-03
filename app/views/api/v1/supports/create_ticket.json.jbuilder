json.ticket @ticket
json.support_conversation @support_conversation
json.support_message do
  json.id  @support_message.id
  json.body @support_message.body
  json.support_conversation_id  @support_message.support_conversation_id
  json.created_at @support_message.created_at
  json.updated_at @support_message.updated_at
  json.read_status @support_message.read_status
  json.sender_id @support_message.sender_id
  json.user_id Admin.admin.first.id
end
json.support_message_image @support_message&.image&.attached? ? @support_message.image.url : ""