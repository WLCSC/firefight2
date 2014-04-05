class Tag < ActiveRecord::Base
    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }
	belongs_to :user
	belongs_to :ticket

	attr_accessor :user_name
	before_create :find_user

	def find_user
		self.user = User.where(:name => self.user_name).first if (self.user_name)
	end

    def name
        "#{user.name} -> ##{ticket.id}"
    end
end
