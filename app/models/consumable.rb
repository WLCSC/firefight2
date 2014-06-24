class Consumable < ActiveRecord::Base
    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }
	has_many :inventories
	has_many :rooms, :through => :inventories
	has_many :alerts
	has_many :uses
	has_many :used_in_rooms, :through => :uses, :foreign_key => :room_id
    validates :target, presence: true

	def total_count
		self.inventories.map{|i| i.count}.inject(0,:+)
	end
end
