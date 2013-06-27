class AddDefaultToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :default_asset_id, :integer

  end
end
