class FixUsers < ActiveRecord::Migration
	def up
		add_column :users, :email, :string
		add_column :users, :administrator, :boolean
		User.all.each do |user|
			user.email = "#{user.username}@wl.k12.in.us"
			user.administrator = (user.privilege == 100)
			user.save
		end
		remove_column :users, :privilege
	end

	def down
	end
end
