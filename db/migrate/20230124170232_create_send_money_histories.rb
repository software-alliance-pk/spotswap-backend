class CreateSendMoneyHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :send_money_histories do |t|
      t.decimal :amount
      t.integer :admin_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
