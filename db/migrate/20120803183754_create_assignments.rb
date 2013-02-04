class CreateAssignments < ActiveRecord::Migration
  def up
    create_table :assignments, :id => false do |t|
      t.integer :user_id
      t.integer :building_id
    end

      User.all.each do |u|
	      Assignment.create!(user_id: u.id, building_id: u.building.id)
      end
  end

  def down
	drop_table :assignments
  end
end
