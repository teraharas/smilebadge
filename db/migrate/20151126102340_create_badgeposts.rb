class CreateBadgeposts < ActiveRecord::Migration
  def change
    create_table :badgeposts do |t|
      t.references :sent_user, index: true
      t.references :recept_user, index: true
      t.references :badge, index: true
      t.text :content

      t.timestamps null: false
      
      t.index [:sent_user_id, :created_at]
      t.index [:recept_user_id, :created_at]
    end
  end
end
