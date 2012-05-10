class FixRooms < ActiveRecord::Migration
  def up
	remove_column :rooms, :availability
  end

  def down
  end
end
