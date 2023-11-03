class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.integer :sender_id, null: false
      t.integer :recepient_id, null: false

      t.timestamps
    end
  end
end
