class AddColumnToSupportMessage < ActiveRecord::Migration[6.1]
  def change
    add_reference :support_messages, :user, null: true, foreign_key: true
  end
end
