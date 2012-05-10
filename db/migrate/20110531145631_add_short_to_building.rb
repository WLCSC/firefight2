class AddShortToBuilding < ActiveRecord::Migration
  def self.up
    add_column :buildings, :short, :string
  end

  def self.down
    remove_column :buildings, :short
  end
end
