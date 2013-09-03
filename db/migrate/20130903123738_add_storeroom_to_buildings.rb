class AddStoreroomToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :storeroom_id, :integer
  end
end
