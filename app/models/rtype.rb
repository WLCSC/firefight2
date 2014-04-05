class Rtype < ActiveRecord::Base
    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }
	has_many :models
	has_many :assets, :through => :models
	has_many :requests
	has_many :loans, :through => :requests
	has_many :tickets, :through => :assets

	attr_accessible :name, :notes, :loanable
end
