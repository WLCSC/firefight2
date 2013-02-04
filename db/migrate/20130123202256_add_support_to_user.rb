class AddSupportToUser < ActiveRecord::Migration
  def change
    add_column :users, :support, :boolean

  end
end
