class Room < ActiveRecord::Base
	has_many :assets
	has_many :tickets, :through => :assets
	belongs_to :building
	has_one :shortcut, :as => :container

	attr_accessible :name, :building_id, :notes

	def add_asset tag, os, model, cost, vendor, notes
		a = Asset.new
		self.assets << a
		a.tag = a.room.building.short + " " + tag
		a.os = os
		a.model = Model.where(:name => model).first
		a.serial = a.tag
		a.cost = cost
		a.vendor = Vendor.where(:name => vendor).first
		a.notes = notes
		a.purchase = Date.today
		a.save
	end
end
