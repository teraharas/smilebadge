class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.string :name
      t.integer :outputnumber
      t.boolean :optionflg
      t.text :explanation
      t.string :image
      t.boolean :remove_image
      t.string :image_cache

      t.timestamps null: false
      
      t.index :outputnumber, unique: true
    end
  end
end
