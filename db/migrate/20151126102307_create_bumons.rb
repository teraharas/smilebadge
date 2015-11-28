class CreateBumons < ActiveRecord::Migration
  def change
    create_table :bumons do |t|
      t.boolean :activeflg
      t.string :name
      t.integer :outputnumber

      t.timestamps null: false
      
      t.index :outputnumber, unique: true
    end
  end
end
