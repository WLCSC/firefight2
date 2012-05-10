class AddRoomToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :room_id, :integer
  end

  def self.down
    remove_column :tickets, :room_id
  end
end
