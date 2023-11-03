class RemoveReadStatusFromSupportConversation < ActiveRecord::Migration[6.1]
  def change
    remove_column :support_conversations, :read_status
    remove_column :support_messages, :read_status
  end
end
