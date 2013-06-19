class Consumable < ActiveRecord::Base
	has_many :inventories
	has_many :rooms, :through => :inventories
	has_many :alerts
	has_many :uses
	has_many :used_in_rooms, :through => :uses, :foreign_key => :room_id

	def total_count
		self.inventories.map{|i| i.count}.inject(0,:+)
	end
end