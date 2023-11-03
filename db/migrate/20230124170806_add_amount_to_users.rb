class AddAmountToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :amount_transfer, :decimal
    add_column :users, :transfer_from, :string
  end
end
