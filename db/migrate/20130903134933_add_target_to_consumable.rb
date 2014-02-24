class AddTargetToConsumable < ActiveRecord::Migration
  def change
    add_column :consumables, :target, :integer
  end
end
