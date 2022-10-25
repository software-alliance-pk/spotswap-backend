class RemoveAndAddTypeAndSenderIdToSupportMessages < ActiveRecord::Migration[6.1]
  def change
    remove_column :support_messages, :user_id
    add_column :support_messages, :sender_id, :integer
    add_column :support_messages, :type, :string
  end
end
