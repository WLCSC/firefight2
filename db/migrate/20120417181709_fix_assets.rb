class FixAssets < ActiveRecord::Migration
  def up
	  remove_column :assets, :rtype_id
  end

  def down
  end
end
