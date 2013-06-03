class Use < ActiveRecord::Base
	belongs_to :consumable
	belongs_to :room
end
