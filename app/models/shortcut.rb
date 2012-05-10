class Shortcut < ActiveRecord::Base
	belongs_to :user
	belongs_to :container, :polymorphic => true
	attr_accessor :container_name
	before_save :find_name

	def find_name
		if self.container_name
			c = nil
			if (c = Ticketqueue.where(:name => self.container_name).first)
				self.container = c
			elsif (c = Building.where(:name => self.container_name).first)
				self.container = c
			elsif (c = User.where(:name => self.container_name).first)
				self.container = c
			else
				self.container_name = self.container_name.split('/').last
				c = Room.where(:name => self.container_name).first
				self.container = c if c
			end
		end
	end
end
