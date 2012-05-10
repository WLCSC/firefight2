class DropVisibilityFromQueues < ActiveRecord::Migration
  def change
	  remove_column :ticketqueues, :visible
  end
end
