json.support_messages @support_messages do |support_message|
  json.id support_message.id
  json.body support_message.body
  json.support_conversation_id support_message.support_conversation_id
  json.read_status support_message.read_status
  json.sender_id support_message.sender_id
  json.recepient_id support_message.user_id
  json.type support_message.type
  json.created_at support_message.created_at
  json.message_image support_message.image.attached? ? support_message.image.url : ""
  json.sender_image User.find_by_id(support_message.sender_id).image.attached? ? User.find_by_id(support_message.sender_id).image.url : ""
end