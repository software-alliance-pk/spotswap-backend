json.parking_slots @parking_slots do |parking_slot|
  json.id parking_slot.id
  json.latitude parking_slot.latitude
  json.longitude parking_slot.longitude
  json.address parking_slot.address
  json.description parking_slot.description
  json.user_id parking_slot.user_id
  json.availability parking_slot.availability
  json.image parking_slot.image.attached? ? parking_slot.image.url : ""
  json.user parking_slot.user
  json.car_detail parking_slot.user.car_detail
  json.car_model_name parking_slot.user.car_detail.car_model.title

  if parking_slot.user.car_detail.photos.attached?
    json.car_images parking_slot.user.car_detail.photos do |photo|
      json.url photo.url
    end
  else
    json.car_images []
  end
end


