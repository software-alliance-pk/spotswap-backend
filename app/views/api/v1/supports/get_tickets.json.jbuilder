json.pending_tickets @pending_tickets do |ticket|
  json.ticket ticket
  json.support_conversation_id ticket&.support_conversation&.id
end

json.completed_tickets @completed_tickets do |ticket|
  json.ticket ticket
  json.support_conversation_id ticket&.support_conversation&.id
end