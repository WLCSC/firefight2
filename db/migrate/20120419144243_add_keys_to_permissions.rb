class AddKeysToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :see, :boolean

    add_column :permissions, :submit, :boolean

    add_column :permissions, :admin, :boolean

  end
end
