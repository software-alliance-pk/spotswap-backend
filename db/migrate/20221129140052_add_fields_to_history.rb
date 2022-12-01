class AddFieldsToHistory < ActiveRecord::Migration[6.1]
  def change
    add_column :histories, :total_fee, :integer
    add_column :histories, :type, :string
    add_column :histories, :swapper_id, :integer, null: false
  end
end
