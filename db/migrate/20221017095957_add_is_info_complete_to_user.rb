class AddIsInfoCompleteToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_info_complete, :boolean, default: false
  end
end
