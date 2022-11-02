class CreateBlockedUserDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :blocked_user_details do |t|
      t.integer :blocked_user_id, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
