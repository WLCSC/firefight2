class Mission < ActiveRecord::Base
    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }
  attr_accessible :ticket_id, :user_id, :ticket, :user
  belongs_to :user
  belongs_to :ticket

  def name
      "#{user.name} -> ##{ticket.id}"
  end
end
