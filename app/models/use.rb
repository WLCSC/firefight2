class Use < ActiveRecord::Base
    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }
	belongs_to :consumable
	belongs_to :room

    def name
        "#{room.name} <- #{consumable.short}"
    end
end
