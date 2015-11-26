class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :bumon, index: true
      t.string :name
      t.string :kananame
      t.boolean :activeflg
      t.boolean :adminflg
      t.string :email
      t.string :password_digest
      t.string :image
      t.boolean :remove_image
      t.string :image_cache
      t.text :myword
      t.text :hobby
      t.text :message

      t.timestamps null: false
      
      t.index :email, unique: true
      t.index :name
      t.index :kananame
    end
  end
end
