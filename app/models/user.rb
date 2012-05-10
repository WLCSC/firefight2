class User < ActiveRecord::Base
	has_many :memberships
	has_many :groups, :through => :memberships
	has_one :principal, :as => :authorizable
	has_many :permissions, :through => :principal
	belongs_to :building
	has_many :tags
	has_many :tickets, :through => :tags
	has_many :comments
	has_many :loans
	has_many :returns, :through => :loan
	after_create :create_principal
	has_many :shortcuts

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

	def ticketqueues
		submittable_queues.to_a
	end

end
