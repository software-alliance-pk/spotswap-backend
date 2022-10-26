class AddIsShowToCarDetails < ActiveRecord::Migration[6.1]
  def change
    add_column :car_details, :is_show, :boolean, default: false
  end
end
