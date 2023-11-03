class AddIsBlockedToConversation < ActiveRecord::Migration[6.1]
  def change
    add_column :conversations, :is_blocked, :boolean, default: false
  end
end
