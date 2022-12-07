class CreateWalletHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :wallet_histories do |t|
      t.integer :top_up_description
      t.string :amount
      t.integer :transaction_type
      t.string :title
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
