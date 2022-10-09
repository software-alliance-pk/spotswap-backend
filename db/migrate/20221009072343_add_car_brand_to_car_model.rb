class AddCarBrandToCarModel < ActiveRecord::Migration[6.1]
  def change
    add_reference :car_models, :car_brand, null: false, foreign_key: true
  end
end
