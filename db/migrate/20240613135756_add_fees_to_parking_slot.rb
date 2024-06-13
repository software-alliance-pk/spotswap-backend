class AddFeesToParkingSlot < ActiveRecord::Migration[6.1]
  def change
    add_column :parking_slots, :fees, :integer
  end
end
