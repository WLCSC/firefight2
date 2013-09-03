class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.integer :user_id
      t.integer :ticket_id

      t.timestamps
    end
  end
end
