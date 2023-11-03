class CreateSupportMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :support_messages do |t|
      t.string :body
      t.integer :read_status
      t.references :user, null: false, foreign_key: true
      t.references :support_conversation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
