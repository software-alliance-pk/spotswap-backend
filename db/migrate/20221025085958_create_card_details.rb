class CreateCardDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :card_details do |t|
      t.string :card_id
      t.integer :exp_month
      t.integer :exp_year
      t.string :brand
      t.string :country
      t.string :fingerprint
      t.string :last_digit
      t.string :name
      t.boolean :is_default, default: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
