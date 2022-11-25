class CreateDefaultPayments < ActiveRecord::Migration[6.1]
  def change
    create_table :default_payments do |t|
      t.string :payment_type
      t.references :card_detail, null: false, foreign_key: true

      t.timestamps
    end
  end
end
