class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.string :body
      t.boolean :read_status, default: false
      t.references :conversation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
