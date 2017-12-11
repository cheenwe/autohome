class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars do |t|
      t.integer :brand_id
      t.string :sub_barnd
      t.string :price
      t.string :remark

      t.timestamps
    end
    add_index :cars, :brand_id
  end
end
