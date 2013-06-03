class Building < ActiveRecord::Base
	has_many :rooms
	has_many :assets, :through => :rooms
	has_many :tickets, :through => :rooms
	has_many :ticketqueues, :as => :parent
	has_one :shortcut, :as => :container
	has_many :assignments
	has_many :asignees, :through => :assignments, :source => :user
	has_many :alerts
	has_many :inventories, :through => :rooms

	attr_accessible :name, :address, :short

	def add_room name, notes
		r = Room.new
		r.name = self.short + " " + name
		r.notes = notes
		self.rooms << r
		r.save
		r
	end

	def nice_name
		self.name
	end

	def techs
		self.asignees.where(:support => true)
	end

	def users
		self.asignees
	end
end
