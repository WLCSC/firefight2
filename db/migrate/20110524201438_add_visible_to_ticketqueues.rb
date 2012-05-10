class AddVisibleToTicketqueues < ActiveRecord::Migration
  def self.up
    add_column :ticketqueues, :visible, :boolean
  end

  def self.down
    remove_column :ticketqueues, :visible
  end
end
