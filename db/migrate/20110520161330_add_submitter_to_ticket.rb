class AddSubmitterToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :submitter_id, :integer
  end

  def self.down
    remove_column :tickets, :submitter_id
  end
end
