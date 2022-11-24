class RemoveNameFromSupport < ActiveRecord::Migration[6.1]
  def change
    remove_column :supports, :name, :string
  end
end
