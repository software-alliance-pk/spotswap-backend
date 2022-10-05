class CreateCarBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :car_brands do |t|
      t.string :title

      t.timestamps
    end
  end
end
