class Mission < ActiveRecord::Base
  attr_accessible :ticket_id, :user_id, :ticket, :user
  belongs_to :user
  belongs_to :ticket
end
