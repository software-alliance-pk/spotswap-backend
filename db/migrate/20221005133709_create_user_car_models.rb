class CreateUserCarModels < ActiveRecord::Migration[6.1]
  def change
    create_table :user_car_models do |t|
      t.references :car_detail, null: false, foreign_key: true
      t.references :car_model, null: false, foreign_key: true

      t.timestamps
    end
  end
end
