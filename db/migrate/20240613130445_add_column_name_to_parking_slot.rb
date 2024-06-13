class AddColumnNameToParkingSlot < ActiveRecord::Migration[6.1]
  def change
    add_column :parking_slots, :amount, :integer
  end
end
