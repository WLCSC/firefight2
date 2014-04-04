class Assignment < ActiveRecord::Base
    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }
	belongs_to :user
	belongs_to :building

    def name
        "#{user.name} -> #{building.short}"
    end
end
