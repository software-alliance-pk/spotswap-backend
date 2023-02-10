class Removeadminidtoadmins < ActiveRecord::Migration[6.1]
  def change
    remove_column :revenues, :admin_id, :bigint
  end
end
