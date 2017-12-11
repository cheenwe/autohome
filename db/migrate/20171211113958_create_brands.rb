class CreateBrands < ActiveRecord::Migration[5.1]
  def change
    create_table :brands do |t|
      t.string :name
      t.string :english_name
      t.string :abbr
      t.string :logo
      t.string :remark

      t.timestamps
    end
  end
end
