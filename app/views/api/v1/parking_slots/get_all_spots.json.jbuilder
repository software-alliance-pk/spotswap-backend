json.parking_slots @parking_slots do |parking_slot|
  json.parking_slot parking_slot
  json.host parking_slot&.user
  json.car_model_name parking_slot&.user.car_detail&.car_model&.title
  json.parking_slot_image parking_slot&.image&.attached? ? parking_slot.image.url : ""
  json.user_image parking_slot&.user&.image&.attached? ? parking_slot.user.image.url : ""
  json.car_image parking_slot&.user&.car_detail&.photos&.attached? ? parking_slot.user.car_detail.photos[0].url : ""
end