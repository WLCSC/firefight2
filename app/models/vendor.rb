class Vendor < ActiveRecord::Base
	has_many :assets
	has_many :tickets, :through => :assets
	attr_accessible :name, :notes

end
