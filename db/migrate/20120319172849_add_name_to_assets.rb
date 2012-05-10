class AddNameToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :name, :string
  end

  def self.down
    remove_column :assets, :name
  end
end
