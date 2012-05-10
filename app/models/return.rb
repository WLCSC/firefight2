class Return < ActiveRecord::Base
	belongs_to :loan
	belongs_to :asset
	has_one :user, :through => :loan
end
