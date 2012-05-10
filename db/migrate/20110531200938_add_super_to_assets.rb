class AddSuperToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :super, :boolean
  end

  def self.down
    remove_column :assets, :super
  end
end
