class Request < ActiveRecord::Base
    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }
	belongs_to :loan
	belongs_to :rtype

    def name 
        "L##{loan.id} -> #{rtype.name}"
    end
end
