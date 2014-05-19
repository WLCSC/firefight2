require 'bcrypt'

class User < ActiveRecord::Base
	has_many :memberships, :dependent => :destroy
	has_many :groups, :through => :memberships
	has_one :principal, :as => :authorizable, :dependent => :destroy
	has_many :permissions, :through => :principal
	belongs_to :building
	has_many :tags, :dependent => :destroy
	has_many :tickets, :through => :tags
	has_many :comments
	has_many :loans
	has_many :returns, :through => :loans
	has_many :alerts
	after_create :create_principal
	before_save :encrypt_password
	has_many :shortcuts
	has_many :assignments, :dependent => :destroy
	has_many :buildings, :through => :assignments
	has_many :missions
	attr_accessor :password
	validates :username, :presence => true
	validates :password, :confirmation => true

	def encrypt_password
		if password
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end

	def create_principal
		self.build_principal.save
	end
	def fqn
		"wlcsc\\#{self.username}"
	end

	def submitted_tickets
		Ticket.where(:submitter_id => self.id)
	end

	def admin?
		administrator
	end

	def support?
		support
	end

	def belongs_to? group
		group.users.include? self
	end

	def member_of? group
		group.users.include? self
	end

	def queues
		if self.admin?
			Ticketqueue.all
		else
			q = []
			Ticketqueue.all.each do |x|
				q << x if x.secures self
			end
			q
		end
	end

	def submittable_queues
		if self.admin?
			Ticketqueue.all
		else
			q = []
			Ticketqueue.all.each do |x|
				q << x if x.secures(self) && x.can_submit?(self) 
			end
			q
		end
	end

	def readable_queues
		if self.admin?
			Ticketqueue.all
		else
			q = []
			Ticketqueue.all.each do |x|
				q << x if x.secures(self) && x.can?(self, :read) 
			end
			q
		end
	end

    def administratable_queues
			q = []
			Ticketqueue.all.each do |x|
				q << x if x.secures(self) && x.can?(self, :admin) 
			end
			q
	end


	def ticketqueues
		submittable_queues.to_a
	end

	def nice_name
		self.name
	end

	def display
		self.name
	end

	def mission_tickets
		self.missions.map{|m| m.ticket }
	end

    def assets
        returns.where(:returned => false).map{|r| r.asset}
    end
end
