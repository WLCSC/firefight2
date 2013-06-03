class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :consumable_id
      t.integer :user_id
      t.integer :building_id
      t.text :message
      t.integer :count

      t.timestamps
    end
  end
end
