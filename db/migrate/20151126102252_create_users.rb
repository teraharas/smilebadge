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
      t.string :remember_digest
      t.string :reset_digest
      t.datetime :reset_sent_at
      t.string :image
      t.boolean :remove_image
      t.string :image_cache
      t.text :myjob
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
