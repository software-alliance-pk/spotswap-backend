class AddDetailsToUserCarModels < ActiveRecord::Migration[6.1]
  def change
    add_column :user_car_models, :title, :string
    add_column :user_car_models, :color, :string
    add_column :user_car_models, :length, :integer
    add_column :user_car_models, :width, :integer
    add_column :user_car_models, :height, :integer
    add_column :user_car_models, :released, :integer
    add_column :user_car_models, :plate_number, :string
  end
end
