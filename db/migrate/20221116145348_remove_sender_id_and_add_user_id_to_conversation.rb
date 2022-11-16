class RemoveSenderIdAndAddUserIdToConversation < ActiveRecord::Migration[6.1]
  def change
    remove_column :conversations, :sender_id
    add_column :conversations, :user_id, :integer, null: false
  end
end
