class CreateParkingSlots < ActiveRecord::Migration[6.1]
  def change
    create_table :parking_slots do |t|
      t.string :description
      t.boolean :availability, default: true

      t.timestamps
    end
  end
end
