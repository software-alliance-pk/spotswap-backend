class CardIdNullFalseToDefaultPayment < ActiveRecord::Migration[6.1]
  def change
    remove_column :default_payments, :card_detail_id
    add_column :default_payments, :card_detail_id, :integer
  end
end
