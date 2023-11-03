class RemoveUserFromSupportMessage < ActiveRecord::Migration[6.1]
  def change
    remove_column :support_messages, :user_id
  end
end
