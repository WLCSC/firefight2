class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :photographable_type
      t.integer :photographable_id
      t.integer :user_id

      t.timestamps
    end
  end
end
