class Return < ActiveRecord::Base
    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }
	belongs_to :loan
	belongs_to :asset
	has_one :user, :through => :loan

    def name 
        "#{user.name} L##{loan.id} -> #{asset.tag}"
    end
end
