class AddFieldsToCarModel < ActiveRecord::Migration[6.1]
  def change
    add_column :car_models, :color, :string
    add_column :car_models, :length, :integer
    add_column :car_models, :width, :integer
    add_column :car_models, :height, :integer
    add_column :car_models, :released, :integer
  end
end
