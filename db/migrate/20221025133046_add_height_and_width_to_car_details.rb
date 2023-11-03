class AddHeightAndWidthToCarDetails < ActiveRecord::Migration[6.1]
  def change
    add_column :car_details, :height, :integer
    add_column :car_details, :width, :integer
  end
end
