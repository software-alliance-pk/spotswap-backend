class AddPlateNumberToCarModels < ActiveRecord::Migration[6.1]
  def change
    add_column :car_models, :plate_number, :string
  end
end
