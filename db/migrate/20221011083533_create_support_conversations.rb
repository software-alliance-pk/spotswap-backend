class CreateSupportConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :support_conversations do |t|
      t.integer :read_status
      t.references :support, null: false, foreign_key: true
      t.integer :recipient_id, null: false
      t.integer :sender_id, null: false

      t.timestamps
    end
  end
end
