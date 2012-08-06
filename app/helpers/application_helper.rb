module ApplicationHelper
	def current_user  
		if session[:user_id]
			current_user ||= User.find(session[:user_id])
			if(session[:override])
				@override = true
				current_user.privilege = session[:override]
			else
				@override = false
			end
			current_user
		else
			current_user = nil
			nil
		end
	end

	def bootstrap_status status
		case status
		when 1
			"-info"
		when 2
			"-warning"
		when 3
			"-important"
		when 99
			"-inverse"
		when 100
			"-success"
		end
	end

	def string_status status
		case status
		when 1
			"Low"
		when 2
			"Routine"
		when 3
			"Urgent"
		when 99
			"Deferred"
		when 100
			"Complete"
		end
	end

	def time_delta time
		if time < Time.now
			distance_of_time_in_words_to_now(time) + " ago"
		else
			distance_of_time_in_words_to_now(time) + " from now"
		end
	end

	def can(right,queue=nil,user=nil)
		raise 'outside of queue' if (@ticketqueue == nil && queue == nil)
		raise 'no user supplied' if (user == nil && current_user == nil)
		return nil if (@ticketqueue == nil && queue == nil)
		x = (queue || @ticketqueue).secures(user || current_user)
		return nil unless x
		return x.can right
	end

	def can? right
		can right
	end

	def badge_row tickets, condensed = false
		arr = (condensed ? [1,2,3] : [1,2,3,99,100])
		if current_user.admin?
			arr.map{|s| '<span class="badge badge' + bootstrap_status(s) + '">' + tickets.where(:status => s).count.to_s + '</span>' }.join("&nbsp;").html_safe 
		else
			('<span class="badge badge-warning">' + tickets.incomplete.count.to_s + '</span>').html_safe

		end
	end

	def tabify list
		r = '<ul class="nav nav-tabs" id="tabs">'
		active = true
		list.each_pair do |li, str|
			if content_for? li
				r << "\n"
				if active
					r << '<li class="active"><a id="tab-'+ li.to_s + '" data-toggle="tab" href="#'+li.to_s+'">'+str+'</a></li>'
					active = false
				else
					r << '<li><a id="tab-'+ li.to_s + '" data-toggle="tab" href="#'+li.to_s+'">'+str+'</a></li>'
				end
				end
		end
		r << '</ul>'
		r << "\n\n"
		r << '<div class="tab-content" style="border: thin inset black; margin-top: 0px; background-color: #ccc">'
		list.each_pair do |li, str|
			if content_for? li
				if !active
					r << '<div class="tab-pane active" id="'+li.to_s+'">'
					active = true
				else
					r << '<div class="tab-pane" id="'+li.to_s+'">'
				end
				r << "\n"
				r << content_for(li)
				r << "\n"
				r << '</div>'
				r << "\n"
			end
		end
		r << '</div>'

		r.html_safe
	end

	def twitterized_type(type)
		case type
		when :alert
			"warning"
		when :error
			"error"
		when :notice
			"info"
		when :success
			"success"
		else
			type.to_s
		end
	end

	def parse_to_datetime str
		str.match /(\d+)\/(\d+)\/(\d+) (\d+):(\d+)/
		DateTime.civil($3.to_i, $1.to_i, $2.to_i, $4.to_i, $5.to_i)
	end
end
