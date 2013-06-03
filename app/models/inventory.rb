class Inventory < ActiveRecord::Base
	belongs_to :consumable
	belongs_to :room
end
