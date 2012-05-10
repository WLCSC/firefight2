class Model < ActiveRecord::Base
	belongs_to :manufacturer
	has_many :assets
	has_many :tickets, :through => :assets
	belongs_to :rtype

	attr_accessible :name, :notes, :manufacturer_id, :rtype_id
end
