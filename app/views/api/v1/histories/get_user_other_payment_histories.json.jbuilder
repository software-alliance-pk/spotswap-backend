
json.payment_histories @payment_histories do |history|
  swapper = User.find_by_id(history.swapper_id)
  host = User.find_by_id(history.host_id)
  json.history_id history.id
  json.swapper swapper
  json.host host
  json.swapper_image swapper.image.attached? ? swapper.image.url : ""
  json.host_image swapper.image.attached? ? host.image.url : ""
  json.swapper_car_model swapper&.car_detail&.car_brand&.title + " " + swapper&.car_detail&.car_model&.title
  json.host_car_model host&.car_detail&.car_brand&.title + " " + host&.car_detail&.car_model&.title
  json.user_type history.user_id == history.swapper_id ? "Swapper" : "Host"  
  json.connection_date_time history.connection_date_time
  json.connection_location history.connection_location
  json.swapper_fee history.swapper_fee
  json.spotswap_fee history.spotswap_fee
  json.total_fee history.total_fee
end
