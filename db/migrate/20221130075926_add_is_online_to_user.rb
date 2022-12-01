class AddIsOnlineToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_online, :boolean, default: false
  end
end
