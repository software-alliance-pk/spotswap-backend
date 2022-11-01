class AddCvcToCardDetail < ActiveRecord::Migration[6.1]
  def change
    add_column :card_details, :card_number, :string
    add_column :card_details, :cvc, :string
  end
end
