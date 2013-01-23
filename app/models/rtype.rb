class Rtype < ActiveRecord::Base
	has_many :models
	has_many :assets, :through => :models
	has_many :requests
	has_many :loans, :through => :requests
	has_many :tickets, :through => :assets

	attr_accessible :name, :notes, :loanable
end
