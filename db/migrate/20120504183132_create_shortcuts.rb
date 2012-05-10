class CreateShortcuts < ActiveRecord::Migration
  def change
    create_table :shortcuts do |t|
      t.integer :user_id
      t.integer :container_id
      t.string :container_type

      t.timestamps
    end
  end
end
