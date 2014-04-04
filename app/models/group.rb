class Group < ActiveRecord::Base
    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }
	has_many :memberships
	has_many :users, :through => :memberships
	has_one :principal, :as => :authorizable
	has_many :permissions, :through => :principal
	after_create :c_principal
	def all_principals
		[self.principal] + self.users.map{|u| u.principal}
	end

	def c_principal
		p = self.build_principal
		p.save
	end

	def display
		self.name
	end
end
