json.parking_slot do
  json.id @parking_slot.id
  json.description @parking_slot.description
  json.availability @parking_slot.availability
  json.image @parking_slot.image.attached? ? rails_blob_url(@parking_slot.image) : ""
end