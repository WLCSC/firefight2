class Manufacturer < ActiveRecord::Base
    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }
	has_many :assets, :through => :models
	has_many :tickets, :through => :assets
	has_many :models

	attr_accessible :name, :notes
end
