class CreatePhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :photos do |t|
      t.integer :car_id
      t.string :name
      t.string :image
      t.string :photo
      t.string :color
      t.string :background
      t.string :price
      t.string :remark

      t.timestamps
    end
    add_index :photos, :car_id
  end
end
