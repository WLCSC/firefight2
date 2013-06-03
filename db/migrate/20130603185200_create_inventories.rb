class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :consumable_id
      t.integer :room_id
      t.integer :count

      t.timestamps
    end
  end
end
