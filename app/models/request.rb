class Request < ActiveRecord::Base
	belongs_to :loan
	belongs_to :rtype
end
