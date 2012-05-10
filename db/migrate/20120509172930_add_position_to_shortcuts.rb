class AddPositionToShortcuts < ActiveRecord::Migration
  def change
    add_column :shortcuts, :position, :integer

  end
end
