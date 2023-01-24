class AddIsDisabledToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_disabled, :boolean, default: false
  end
end
