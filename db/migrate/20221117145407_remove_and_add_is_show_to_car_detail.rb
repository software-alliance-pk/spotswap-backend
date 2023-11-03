class RemoveAndAddIsShowToCarDetail < ActiveRecord::Migration[6.1]
  def change
    remove_column :car_details, :is_show
    add_column :car_details, :is_show, :boolean, default: true
  end
end
