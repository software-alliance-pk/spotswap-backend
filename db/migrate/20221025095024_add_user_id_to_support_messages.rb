class AddUserIdToSupportMessages < ActiveRecord::Migration[6.1]
  def change
    add_reference :support_messages, :user, null: false, foreign_key: true
  end
end
