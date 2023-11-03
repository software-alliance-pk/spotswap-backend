class AddIsDefaultToWallet < ActiveRecord::Migration[6.1]
  def change
    add_column :wallets, :is_default, :boolean, default: false
    add_column :wallets, :payment_type, :integer
  end
end
