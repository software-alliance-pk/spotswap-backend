json.parking_slot do
  json.partial! 'shared/parking_slot_details', parking_slot: @slot
end
