class Permission < ActiveRecord::Base
	belongs_to :principal
	belongs_to :securable, :polymorphic => true
	attr_accessor :user_name, :group_name
	before_create :find_principal

	def find_principal
		if self.user_name
			self.principal = User.where(:name => self.user_name).first.principal
			return true
		end
		if self.group_name
			self.principal = Group.where(:name => self.user_name).first.principal
			return true
		end
		nil
	end

	def authorizes? user
		self.principal.authorizes? user
	end

	def can right
		right = right.to_s
		case right
		when /see/
			self.see
		when /submit/
			self.submit
		when /admin/
			self.admin
		else nil
		end
	end

	def can? right
		can right
	end
end
