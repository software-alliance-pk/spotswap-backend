class AddLoginTypeInUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :profile_complete, :boolean, default: false
    add_column :users, :profile_type, :string
  end
end
