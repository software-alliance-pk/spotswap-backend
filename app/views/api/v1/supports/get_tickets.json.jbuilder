json.pending_tickets @pending_tickets do |ticket|
  json.ticket ticket
  json.image ticket.image.attached? ? rails_blob_url(ticket.image) : ""
end

json.completed_tickets @completed_tickets do |ticket|
  json.ticket ticket
  json.image ticket.image.attached? ? rails_blob_url(ticket.image) : ""
end