class RemoveAndAddAvailabilityToParkingSlot < ActiveRecord::Migration[6.1]
  def change
    remove_column :parking_slots, :availability
    add_column :parking_slots, :availability, :boolean, default: false
  end
end
