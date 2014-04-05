class Vendor < ActiveRecord::Base
    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }
	has_many :assets
	has_many :tickets, :through => :assets
	attr_accessible :name, :notes

end
