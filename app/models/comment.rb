require 'net/http'

class Comment < ActiveRecord::Base
	belongs_to :ticket
	belongs_to :user

	attr_accessible :ticket_id, :user_id, :content
	after_create :check_inventory
	validates :content, :presence => true

	def check_inventory
		if (md = content.match(/#\{(\w+)\}/))
			uri = URI('http://tonermonkey/orders/quick')
			res = Net::HTTP.post_form(uri, username: self.user.username, store: self.ticket.room.building.name, item_tag: md[1])
			content.gsub(/#\{(\w+)\}/,'<a href="http://tonermonkey"><img src="/assets/monkey.png" alt="TonerMonkey"/>\\1</a>')
		end
	end

end
