class CreateCarDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :car_details do |t|
      t.integer :length
      t.string :color
      t.string :plate_number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
