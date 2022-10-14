json.ticket @ticket
json.image @ticket.image.attached? ? rails_blob_url(@ticket.image) : ""
json.support_conversation @support_conversation
json.support_message @support_message
json.support_message_image @support_message.image.attached? ? rails_blob_url(@support_message.image) : ""