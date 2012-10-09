require 'net/http'

class Comment < ActiveRecord::Base
	belongs_to :ticket
	belongs_to :user

	attr_accessible :ticket_id, :user_id, :content
	after_create :check_inventory
	validates :content, :presence => true

	def check_inventory
		if (md = content.match(/#\{(.+)\}/))
			uri = URI('http://tonermonkey.wlcsc.k12.in.us/orders/quick')
			res = Net::HTTP.post_form(uri, username: self.user.username, store: self.ticket.room.building.name, item_tag: md[1])
			content.gsub!(/#\{(.+)\}/,'<a href="http://tonermonkey.wlcsc.k12.in.us"><img src="/assets/monkey.png" alt="TonerMonkey"/>\\1</a>')
			self.save
		end

		if (md = content.match(/#\[(.+)\]/))
			content.gsub!(/#\[(.+)\]/,'<a href="http://firefight.wlcsc.k12.in.us/tickets/' + md[1] + '"><span class="badge">\\1</span></a>')
			self.save
		end
	end

end
