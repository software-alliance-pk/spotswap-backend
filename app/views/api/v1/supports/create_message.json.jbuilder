json.support_message do
  json.id @support_message.id
  json.body @support_message.body
  json.user_id @support_message.user_id
  json.support_conversation_id @support_message.support_conversation_id
  json.read_status @support_message.read_status
  json.support_message_image @support_message.image.attached? ? rails_blob_url(@support_message.image) : ""
end