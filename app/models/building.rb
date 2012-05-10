class Building < ActiveRecord::Base
	has_many :rooms
	has_many :assets, :through => :rooms
	has_many :tickets, :through => :rooms
	has_many :users
	has_many :ticketqueues, :as => :parent
	has_one :shortcut, :as => :container

	attr_accessible :name, :address, :short

	def add_room name, notes
		r = Room.new
		r.name = self.short + " " + name
		r.notes = notes
		self.rooms << r
		r.save
		r
	end
end
