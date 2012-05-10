class CreateQueues < ActiveRecord::Migration
  def self.up
    create_table :ticketqueues do |t|
      t.string :name
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :ticketqueues
  end
end
