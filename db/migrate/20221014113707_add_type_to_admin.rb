class AddTypeToAdmin < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :category, :integer, default: 0
  end
end
