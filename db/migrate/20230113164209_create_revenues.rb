class CreateRevenues < ActiveRecord::Migration[6.1]
  def change
    create_table :revenues do |t|
      t.integer :amount
      t.references :admin

      t.timestamps
    end
  end
end
