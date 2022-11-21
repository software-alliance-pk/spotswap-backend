json.ticket @ticket
json.image @ticket&.image&.attached? ? @ticket.image.url : ""
json.support_conversation @support_conversation
json.support_message @support_message
json.support_message_image @support_message&.image&.attached? ? @support_message.image.url : ""