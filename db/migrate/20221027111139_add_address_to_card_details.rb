class AddAddressToCardDetails < ActiveRecord::Migration[6.1]
  def change
    add_column :card_details, :address, :string
  end
end
