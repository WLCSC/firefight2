class Ticketqueue < ActiveRecord::Base
    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }
	has_many :tickets
	has_many :permissions, :as => :securable
	has_many :principals, :through => :permissions
	belongs_to :parent, :polymorphic => true
	has_many :ticketqueues, :as => :parent
	has_many :shortcuts, :as => :container

	before_save :find_parent
	attr_accessor :parent_name

	attr_accessible :name, :notes, :visible, :parent_name

	def secures user
		self.permissions.sort{|a,b| a.priority <=> b.priority}.each do |p|
			if (p.authorizes? user)
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
		p = secures(user)
        puts p.inspect
		r = nil
		if p
			case right
			when :read, :see
				r=p.see || user.admin?
			when :write, :submit
				r=p.submit || user.admin?
			when :execute, :admin
				r=p.admin
			end
		else
			r=false || user.admin?
		end
		puts "Chamber##{self.id}: can #{user.name} #{right.to_s}: #{r}"
		r
	end

	def permissions
		Permission.where(:securable_type => "Ticketqueue").where(:securable_id => self.id)
	end

	def can_submit? user
		self.secures(user).can?(:submit)
	end

	def find_parent
		if self.parent_name
			self.parent = Ticketqueue.where(:name => self.parent_name).first || Building.where(:name => self.parent_name).first
		end
	end

	def nice_name
		self.name
	end

end
