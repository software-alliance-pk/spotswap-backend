json.parking_slot do
  json.id parking_slot.id
  json.latitude parking_slot.latitude
  json.longitude parking_slot.longitude
  json.address parking_slot.address
  json.description parking_slot.description
  json.availability parking_slot.availability
  json.image parking_slot.image.attached? ? parking_slot.image.url : ""
end