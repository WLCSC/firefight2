class Manufacturer < ActiveRecord::Base
	has_many :assets, :through => :models
	has_many :tickets, :through => :assets
	has_many :models

	attr_accessible :name, :notes
end
