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
	before_save :fix_room

	attr_accessor :room_name, :purchase_date, :model_name
	attr_accessible :room_id, :tag, :rtype_id, :os, :manufacturer_id, :model_id, :serial, :purchase, :cost, :vendor_id, :notes, :super, :name, :room_name, :purchase_date, :room_name, :model_name

	validates_presence_of :tag
	validates_uniqueness_of :tag

	def fix_room
		if self.room_name
			r = self.room_name.split(' - ')
			self.room = Room.where(:name => r[1]).where(:building_id => Building.where(:name => r[0]).first.id).first
		end

		if self.purchase_date
			self.purchase_date.match /(\d+)\/(\d+)\/(\d+)/
			begin
			self.purchase = Date.civil($3.to_i, $1.to_i, $2.to_i)
			rescue
				self.errors.add(:purchase_date, "is incorrectly formatted.")
			end
		end

		if self.model_name && !self.model_name.empty?
			r = self.model_name.split(' - ')
			self.model = Model.where(:name => r[1]).where(:manufacturer_id => Manufacturer.where(:name => r[0]).first.id).first
		else
			self.errors.add :model, "doesn't exist."
		end


	end

    def loaned?
        returns.where(:returned => false).first
    end

    def loaned_to
        returns.where(:returned => false).first.loan.user
    end
end
