class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.integer :room_id
      t.string :tag
      t.integer :rtype_id
      t.string :os
      t.integer :model_id
      t.string :serial
      t.date :purchase
      t.integer :cost
      t.integer :vendor_id
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
