class AddPaymentTypeToCardDetails < ActiveRecord::Migration[6.1]
  def change
    add_column :card_details, :payment_type, :integer
  end
end
