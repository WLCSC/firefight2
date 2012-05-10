class Ticketqueue < ActiveRecord::Base
	has_many :tickets
	has_many :permissions, :as => :securable
	has_many :principals, :through => :permissions
	belongs_to :parent, :polymorphic => true
	has_many :ticketqueues, :as => :parent
	has_one :shortcut, :as => :container

	before_save :find_parent
	attr_accessor :parent_name

	attr_accessible :name, :notes, :visible, :parent_name

	def secures user
		self.permissions.sort{|a,b| a.priority <=> b.priority}.each do |p|
			if (p.authorizes? user) && (p.see)
				return p
			end
		end
		nil
	end

	def secures_without user, skip
		self.permissions.sort{|a,b| a.priority <=> b.priority}.each do |p|
			return p if p.authorizes? user && p != skip
		end
	end

	def users
		self.principals.map {|x| x.users}.flatten.uniq
	end

	def can? user, right
		p = self.permissions.where(:user_id => user.id).where(:key => right).order('priority').first
		p.value == 1
	end

	def permissions
		Permission.where(:securable_type => "Ticketqueue").where(:securable_id => self.id)
	end

	def can_submit? user
		self.permissions.where(:principal_id => user.principal.id).where(:submit => true).count > 0
	end

	def find_parent
		if self.parent_name
			self.parent = Ticketqueue.where(:name => self.parent_name).first || Building.where(:name => self.parent_name).first
		end
	end
end
