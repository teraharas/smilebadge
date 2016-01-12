class CreateMongons < ActiveRecord::Migration
  def change
    create_table :mongons do |t|
      t.integer :kubun
      t.text :content

      t.timestamps null: false
    end
  end
end
