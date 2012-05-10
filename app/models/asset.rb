class Asset < ActiveRecord::Base
	belongs_to :room
	has_one :building, :through => :room
	has_one :manufacturer, :through => :model
	belongs_to :model
	has_one :rtype, :through => :model
	belongs_to :vendor
	has_many :tickets
	has_many :returns
	has_many :loans, :through => :returns

	attr_accessible :room_id, :tag, :rtype_id, :os, :manufacturer_id, :model_id, :serial, :purchase, :cost, :vendor_id, :notes, :super, :name

	validates_presence_of :tag
	validates_uniqueness_of :tag
end
