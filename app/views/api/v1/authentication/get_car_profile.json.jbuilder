json.profile do
  json.car_detail_id @car_detail.id
  json.car_length @car_detail.length
  json.car_color  @car_detail.color
  json.plate_number @car_detail.plate_number
  json.car_brand @car_detail.car_brand.title
  json.car_model @car_detail.car_model.title
  json.default_image @car_detail.default_image.attached? ? rails_blob_url(@car_detail.default_image)  : ""
  json.photos @car_detail.photos do |photo|
      json.url rails_blob_url(photo)
  end
end