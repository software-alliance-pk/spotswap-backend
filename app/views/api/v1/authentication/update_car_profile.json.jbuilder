json.profile do
  json.user_id @car_detail.user_id
  json.car_detail_id @car_detail.id
  json.car_length @car_detail.length
  json.car_width @car_detail.width
  json.car_height @car_detail.height
  json.car_color @car_detail.color
  json.plate_number @car_detail.plate_number
  json.car_brand @car_detail.car_brand.title
  json.car_model @car_detail.car_model.title
  if @car_detail.photos.attached?
    json.photos @car_detail.photos do |photo|
      json.url photo.url
    end
  else
    json.photos []
  end
end