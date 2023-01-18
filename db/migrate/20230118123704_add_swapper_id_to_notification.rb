class AddSwapperIdToNotification < ActiveRecord::Migration[6.1]
  def change
    remove_column :notifications, :notifiable_type
    remove_column :notifications, :notifiable_id
    add_column :notifications, :swapper_id, :integer
    add_column :notifications, :host_id, :integer
  end
end
