json.car_brand @info do |record|
  json.id record.id
  json.name record.title
  json.image record.image.attached? ? record.image.url : ""
  json.car_models record.car_models do |cmodel|
    json.id  cmodel.id
    json.name cmodel.title
  end
end