class AddDeptToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :department_id, :integer

  end
end
