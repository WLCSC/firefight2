require 'net/http'

#SimpleLdapAuthenticator.servers = [APP_CONFIG[:ldap_domain_controller]]
class Comment < ActiveRecord::Base
	belongs_to :ticket
	belongs_to :user

	attr_accessible :ticket_id, :user_id, :content
	before_save :check_inventory
	validates :content, :presence => true

	def check_inventory
		#if ((md = content.match(/#\{(.+)\}/)) && APP_CONFIG[:tonermonkey_integration])
		#	uri = URI(APP_CONFIG[:tonermonkey_url] + '/orders/quick')
		#	res = Net::HTTP.post_form(uri, username: self.user.username, store: self.ticket.room.building.name, item_tag: md[1])
		#	content.gsub!(/#\{(.+)\}/,'<a href="' + APP_CONFIG[:tonermonkey_url] + '"><img src="/assets/monkey.png" alt="TonerMonkey"/>\\1</a>')
		#	self.save
		#end

		#if (md = content.match(/#\[(.+)\]/))
		#	content.gsub!(/#\[(.+)\]/,'<a href="https://apps.wl.k12.in.us/firefight/tickets/' + md[1] + '"><span class="badge">\\1</span></a>')
		#	self.save
		#end

		#if (md = content.match(/#\((.+)\)/))
		#	asset = Asset.where(:tag => md[1]).first
		#	asset = Asset.where(:name => md[1]).first unless tag

		#	if tag
		#		content.gsub!(/#\((.+)\)/,'<a href="https://apps.wl.k12.in.us/firefight/assets/' + asset.tag + '"><span class="badge badge-inverse">\\1</span></a>')
		#	end
		#end

		content.gsub!(/#\{(.+?)\}/) do |cmd|
			md = cmd.match /#\{(.+)\}/
			args = md[1].split ':'
			op = args.delete_at 0

			q = "[Invalid Operation]"
			case op
				when /use/i
					consumable = Consumable.where(:name => args[0]).first
					consumable = Consumable.where(:short => args[0]).first unless consumable
					room = self.ticket.room
					inv = room.inventories.where(:consumable_id => consumable.id).first
					inv.count -= args[1].to_i
					inv.save

					q = '<a href="https://apps.wl.k12.in.us/firefight/rooms/' + room.id.to_s + '">' 
					q += "[Used #{args[1]} #{args[0]}]</a>" 	

				when /ticket/i
					q = '<a href="https://apps.wl.k12.in.us/firefight/tickets/' + args[0] + '"><span class="badge">' 
					q += args[0] + '</span></a>'	
				when /asset/i
					a = Asset.where(:tag => args[0]).first
					a = Asset.where(:name => args[0]).first unless a
					if a
						q = '<a href="https://apps.wl.k12.in.us/firefight/assets/' + a.id.to_s + '"><span class="badge badge-inverse">' 
						q += a.tag + '</span></a>'	
					else
						q = "[Unknown asset #{args[0]}]"
					end
				else
					q = "[Unknown operation - #{op} - #{args}]"
			end
			q
		end
	end

	def formatted_display
		self.content.lines.map{|l| "<p>#{l}</p>"}.join("\n").html_safe
	end

end
