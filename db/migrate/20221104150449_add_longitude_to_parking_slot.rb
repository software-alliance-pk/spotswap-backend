class AddLongitudeToParkingSlot < ActiveRecord::Migration[6.1]
  def change
    add_column :parking_slots, :longitude, :float
    add_column :parking_slots, :latitude, :float
    add_column :parking_slots, :address, :string
  end
end
