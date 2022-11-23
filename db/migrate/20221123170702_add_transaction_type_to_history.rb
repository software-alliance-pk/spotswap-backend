class AddTransactionTypeToHistory < ActiveRecord::Migration[6.1]
  def change
    add_column :histories, :transaction_type, :integer
  end
end
