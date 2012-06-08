class Room < ActiveRecord::Base
	has_many :assets
	has_many :tickets, :through => :assets
	belongs_to :building
	has_one :shortcut, :as => :container
	belongs_to :department
	belongs_to :default_asset, :class_name => :Asset

	attr_accessible :name, :building_id, :notes, :department_id, :default_asset_id

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
