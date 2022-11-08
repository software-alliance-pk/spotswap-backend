class AddUserToParkingSlot < ActiveRecord::Migration[6.1]
  def change
    add_reference :parking_slots, :user, null: false, foreign_key: true
  end
end
