require 'net/http'

#SimpleLdapAuthenticator.servers = [APP_CONFIG[:ldap_domain_controller]]
class Comment < ActiveRecord::Base
	belongs_to :ticket
	belongs_to :user

	attr_accessible :ticket_id, :user_id, :content
	after_create :check_inventory
	validates :content, :presence => true

	def check_inventory
		if ((md = content.match(/#\{(.+)\}/)) && APP_CONFIG[:tonermonkey_integration])
			uri = URI(APP_CONFIG[:tonermonkey_url] + '/orders/quick')
			res = Net::HTTP.post_form(uri, username: self.user.username, store: self.ticket.room.building.name, item_tag: md[1])
			content.gsub!(/#\{(.+)\}/,'<a href="' + APP_CONFIG[:tonermonkey_url] + '"><img src="/assets/monkey.png" alt="TonerMonkey"/>\\1</a>')
			self.save
		end

		if (md = content.match(/#\[(.+)\]/))
			content.gsub!(/#\[(.+)\]/,'<a href="https://apps.wl.k12.in.us/firefight/tickets/' + md[1] + '"><span class="badge">\\1</span></a>')
			self.save
		end
	end

	def formatted_display
		self.content.lines.map{|l| "<p>#{l}</p>"}.join("\n").html_safe
	end

end
