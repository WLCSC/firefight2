class HabtmForTicketUsers < ActiveRecord::Migration
  def self.up
	create_table :tickets_users, :id => false do |t|
		t.references :ticket, :null => false
		t.references :user, :null => false
	end
  end

  def self.down
  end
end
