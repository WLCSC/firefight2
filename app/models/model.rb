class Model < ActiveRecord::Base
    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }
	belongs_to :manufacturer
	has_many :assets
	has_many :tickets, :through => :assets
	belongs_to :rtype

	attr_accessible :name, :notes, :manufacturer_id, :rtype_id
end
