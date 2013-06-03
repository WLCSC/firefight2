class Room < ActiveRecord::Base
	has_many :assets
	has_many :tickets, :through => :assets
	belongs_to :building
	has_one :shortcut, :as => :container
	belongs_to :department
	belongs_to :default_asset, :class_name => :Asset
	has_many :inventories
	has_many :consumables, :through => :inventories
	before_save :fix_default_tag
	after_create :add_default_asset

	attr_accessible :name, :building_id, :notes, :department_id, :default_asset_id, :default_asset_tag
	attr_accessor :default_asset_tag


	def fix_default_tag
		if self.default_asset_tag
			self.default_asset = Asset.where(:tag => self.default_asset_tag).first
		end
	end
	def add_asset tag, os, model, cost, vendor, notes
		a = Asset.new
		self.assets << a
		a.tag = a.room.building.short + "-" + tag
		a.os = os
		a.model = Model.where(:name => model).first
		a.serial = a.tag
		a.cost = cost
		a.vendor = Vendor.where(:name => vendor).first
		a.notes = notes
		a.purchase = Date.today
		a.save
		a
	end


	def add_default_asset
		a = add_asset self.name, '', "ROOM", 0, 'n/a', ''
		self.default_asset = a
		self.save
	end

	def nice_name
		self.building.short + "-" + self.name
	end

	def self.to_csv
		CSV.generate do |csv|
			all.each do |room|
				begin
					csv << [room.name, room.building ? room.building.name : "None", room.department ? room.department.name : "None", room.notes ]
				rescue
				end
			end
		end
	end
end
