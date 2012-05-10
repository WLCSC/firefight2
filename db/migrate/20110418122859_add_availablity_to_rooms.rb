class AddAvailablityToRooms < ActiveRecord::Migration
  def self.up
    add_column :rooms, :availability, :text
  end

  def self.down
    remove_column :rooms, :availability
  end
end
