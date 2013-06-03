class Alert < ActiveRecord::Base
	belongs_to :user
	belongs_to :building
	belongs_to :consumable
end
