class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :subject
      t.string :body
      t.string :notifiable_type
      t.integer :notifiable_id
      t.boolean :is_clear, default: false
      t.string :notify_by

      t.timestamps
    end
  end
end
