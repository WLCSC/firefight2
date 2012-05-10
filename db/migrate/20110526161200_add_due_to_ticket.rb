class AddDueToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :due, :datetime
  end

  def self.down
    remove_column :tickets, :due
  end
end
