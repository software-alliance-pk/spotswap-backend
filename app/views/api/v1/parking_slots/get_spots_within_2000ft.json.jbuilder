json.parking_slots @parking_slots do |parking_slot|
  json.partial! 'shared/parking_slot_details', parking_slot: parking_slot
end