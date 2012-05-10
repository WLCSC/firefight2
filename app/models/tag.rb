class Tag < ActiveRecord::Base
	belongs_to :user
	belongs_to :ticket

	attr_accessor :user_name
	before_create :find_user

	def find_user
		self.user = User.where(:name => self.user_name).first if (self.user_name)
	end
end
