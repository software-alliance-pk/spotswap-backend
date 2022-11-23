class CreateHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|
      t.datetime :connection_date_time
      t.string :connection_location
      t.integer :swapper_fee
      t.integer :spotswap_fee
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
