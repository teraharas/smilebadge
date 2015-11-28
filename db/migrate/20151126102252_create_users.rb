class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :activeflg, default: true
      t.references :bumon, index: true
      t.string :name
      t.string :kananame
      t.string :nickname
      t.boolean :adminflg, default: false
      t.string :email
      t.string :password_digest
      t.string :image1
      t.boolean :remove_image1
      t.string :image_cache1
      t.string :image2
      t.boolean :remove_image2
      t.string :image_cache2
      t.text :myword
      t.text :hobby
      t.string :message

      t.timestamps null: false
      
      t.index :email, unique: true
      t.index :name
      t.index :kananame
    end
  end
end
