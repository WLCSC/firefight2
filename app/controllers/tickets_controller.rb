class TicketsController < ApplicationController
	include ApplicationHelper
	before_filter :check_for_admin, :only => ['destroy']
	# GET /tickets
	# GET /tickets.json
	def index
		@tickets = []
		if params[:status] || params[:building_id] || params[:queue_id] || params[:rangeEnd] || params[:rangeStart]
			@tickets = Ticket.readable_by(current_user)
			if params[:status]
				case params[:status]
				when 'a'
					@tickets = @tickets.where(:status => [1,2,3,99,100])
				when 'i'
					@tickets = @tickets.where(:status => [1,2,3,99])
				when 'c'
					@tickets = @tickets.where(:status => 100)
				when 'l'
					@tickets = @tickets.where(:status => 1)
				when 'r'
					@tickets = @tickets.where(:status => 2)
				when 'u'
					@tickets = @tickets.where(:status => 3)
				when 'd'
					@tickets = @tickets.where(:status => 99)
				end
			else
				@tickets = @tickets.where(:status => [1,2,3,99])
			end
			if params[:rangeStart] && params[:rangeStart] != ''
				dx = parse_to_datetime(params[:rangeStart])
				@tickets = @tickets.where('created_at >= ?',dx)
			end
			if params[:rangeEnd] && params[:rangeEnd] != ''
				dx = parse_to_datetime(params[:rangeEnd])
				@tickets = @tickets.where('created_at <= ?',dx)
			end
			if params[:building_id] && params[:building_id] != ""
				@tickets= @tickets.where(:room_id => Building.find(params[:building_id]).room_ids)
			end
			if params[:queue_id] && params[:queue_id] != ""
				@tickets= @tickets.where(:ticketqueue_id => params[:queue_id])
			end
			if params[:match] && params[:match] != ''
				regex = Regexp.new(params[:match], 1)
				@tickets.keep_if{|t| t.comments.keep_if{|c| c.content.match(regex)}.count > 0}  
			end
		end

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @tickets }
		end
	end

	# GET /tickets/1
	# GET /tickets/1.json
	def show
		@ticket = Ticket.find(params[:id])
		unless current_user.ticketqueues.include?(@ticket.ticketqueue) || current_user.admin? || @ticket.users.include?(current_user)
			redirect_to root_path, :notice => "You don't have permission to read that." 
		else
			respond_to do |format|
				format.html # show.html.erb
				format.json { render json: @ticket }
			end
		end
	end

	# GET /tickets/new
	# GET /tickets/new.json
	def new
		@ticket = Ticket.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @ticket }
		end
	end

	# GET /tickets/1/edit
	def edit
		@ticket = Ticket.find(params[:id])
		unless current_user.ticketqueues.include?(@ticket.ticketqueue) || current_user.admin? 
			redirect_to root_path, :notice => "You don't have permission to edit that." 
		end
	end

	# POST /tickets
	# POST /tickets.json
	def create
		@ticket = Ticket.new(params[:ticket])
		if params[:ticket][:photo][:image]
			@photo = Photo.new(@ticket.photo)
			@ticket.photos << @photo
		end	
		unless current_user.ticketqueues.include?(@ticket.ticketqueue) || current_user.admin? || @ticket.users.include?(current_user)
			redirect_to root_path, :notice => "You don't have permission to do that." 
			return
		else


			if @ticket.ticketqueue == nil
				@ticket.ticketqueue = Ticketqueue.first
			end
			if @ticket.asset == nil 
				if @ticket.room != nil
					@ticket.asset = @ticket.room.asset
				else
					@ticket.errors << "Something has gone horribly wrong!"
				end
			end

			respond_to do |format|
				if @ticket.save && (!@photo || (@photo && @photo.save))
					begin
						MailMan.ticket_submitted(current_user.id, @ticket.id, @ticket.comments.first.id).deliver
					rescue => exc
						ExceptionNotifier::Notifier.exception_notification(request.env, exc, :data => {:message => "failed to deliver mail"}).deliver
					end

					notifications = []
					User.where(:administrator => true).each {|u| notifications << u}
					@ticket.asset.building.techs.each {|u| notifications << u if @ticket.ticketqueue.can?(u, :see)}
					@ticket.asset.building.shortcuts.map{|s| s.user}.each {|u| notifications << u if @ticket.ticketqueue.can?(u, :see)}
					@ticket.asset.room.shortcuts.map{|s| s.user}.each {|u| notifications << u if @ticket.ticketqueue.can?(u, :see)}
					@ticket.submitter.shortcuts.map{|s| s.user}.each {|u| notifications << u if @ticket.ticketqueue.can?(u, :see)}
					@ticket.ticketqueue.shortcuts.map{|s| s.user}.each {|u| notifications << u if @ticket.ticketqueue.can?(u, :see)}
					notifications.uniq!

					notifications.each do |u|
						begin
							MailMan.tech_submitted(u.id, @ticket.id, @ticket.comments.first.id).deliver unless @ticket.submitter == u
						rescue
							ExceptionNotifier::Notifier.exception_notification(request.env, exc, :data => {:message => "failed to deliver mail"}).deliver
						end
					end
					if params[:ticket][:photo][:image]
						@photo = Photo.new(params[:ticket][:photo])
						@photo.photographable_id = @ticket.id
						@photo.save
					end
					format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
					format.json { render json: @ticket, status: :created, location: @ticket }
				else
					format.html { redirect_to @ticket.asset, notice: @ticket.errors.full_messages.join('<br />').html_safe }
					format.json { render json: @ticket.errors, status: :unprocessable_entity }
				end
			end
		end
	end

	# PUT /tickets/1
	# PUT /tickets/1.json
	def update
		@ticket = Ticket.find(params[:id])
		unless current_user.ticketqueues.include?(@ticket.ticketqueue) || current_user.admin? || @ticket.users.include?(current_user)
			redirect_to root_path, :notice => "You don't have permission to read that." 
		else

			respond_to do |format|
				if @ticket.update_attributes(params[:ticket])
					@ticket.users << current_user unless @ticket.users.include? current_user
					if params[:commit] = "OK" && params[:status]
						c = Comment.create!(:user_id => current_user.id, :ticket_id => @ticket.id, :content => "#{current_user.name} changed the status of this ticket to #{string_status(@ticket.status)}")
					end

					if @ticket.status == 100 && !@ticket.assigned?
						User.where(:administrator => :true).each do |u|
							MailMan.ticket_updated(@ticket.id,u.id)
						end
					end


					if params[:commit] == "Move"
						c = Comment.create!(:user_id => current_user.id, :ticket_id => @ticket.id, :content => "#{current_user.name} moved this ticket to Tag##{@ticket.asset.tag}")
					end

					@ticket.users.each do |u|
						MailMan.ticket_updated(@ticket.id, u.id).deliver
					end

					format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
					format.json { head :no_content }
				else
					format.html { render action: "edit" }
					format.json { render json: @ticket.errors, status: :unprocessable_entity }
				end
			end
		end
	end

	# DELETE /tickets/1
	# DELETE /tickets/1.json
	#	def destroy
	#		@ticket = Ticket.find(params[:id])
	#		@ticket.destroy
	#
	#		respond_to do |format|
	#			format.html { redirect_to tickets_url }
	#			format.json { head :no_content }
	#		end
	#	end

	def tagchange
		@ticket = Ticket.find(params[:id])
		unless current_user.ticketqueues.include?(@ticket.ticketqueue) || current_user.admin? || @ticket.users.include?(current_user)
			redirect_to root_path, :notice => "You don't have permission to do that." 
		else
			if params[:user]
				@user = User.find(params[:user])
			elsif params[:user_name]
				@user = User.where(:name => params[:user_name]).first
			else
				@user = current_user
			end

			if @user
				if @ticket.users.include? @user
					@ticket.users.delete(@user)
				else
					@ticket.users << @user
				end
				redirect_to ticket_path(@ticket), info: "Tagged user."
			else
				redirect_to ticket_path(@ticket), info: "Could not tag #{params[:user_name] || params[:user]}."
			end
		end
	end

	def untag
		@ticket = Ticket.find(params[:id])
		unless current_user.ticketqueues.include?(@ticket.ticketqueue) || current_user.admin? || @ticket.users.include?(current_user)
			render :js => '$("#flashbox").append(\'<div class="alert">You can\'t do that.</div>\');'
		else
			@user = User.find(params[:user_id])
			if @user && @ticket.users.include?(@user)
				@ticket.users.delete(@user)
			else
				render :js => '$("#flashbox").append(\'<div class="alert"><button type="button" class="close" data-dismiss="alert">&times</button>That user isn\'t tagged here.</div>\');'
			end
		end	
	end

	def tag
		@ticket = Ticket.find(params[:id])
		unless current_user.ticketqueues.include?(@ticket.ticketqueue) || current_user.admin? || @ticket.users.include?(current_user)
			render :js => '$("#flashbox").append(\'<div class="alert">You can\'t do that.</div>\');'
		else
			if params[:user]
				@user = User.find(params[:user])
			elsif params[:user_name]
				@user = User.where(:name => params[:user_name]).first
			else
				@user = current_user
			end
			if @user 
				if @ticket.users.include? @user
					render :nothing => true
				else
					@ticket.users << @user
				end
			else
				render :js => '$("#flashbox").append(\'<div class="alert"><button type="button" class="close" data-dismiss="alert">&times</button>Who is that??</div>\');'
			end
		end	
	end


	def mass
		if current_user.admin?
			b = (params[:building_id] == '0' ? nil : Building.find(params[:building_id]))
			d = (params[:department_id] == '0' ? nil : Department.find(params[:department_id]))
			@rooms = []
			if b
				if d
					@rooms = b.rooms & d.rooms
				else
					@rooms = b.rooms
				end

			else
				if d
					@rooms = d.rooms
				else
					@rooms = Room.all
				end
			end


			@rooms.each do |r|
				t = Ticket.create(:room_id => r.id, :comment => params[:comment], :submitter_id => params[:submitter_id], :ticketqueue_id => params[:ticketqueue_id], :status => params[:status], :due_at => params[:due_at], :asset_id => r.default_asset.id)
				t.save
			end

			redirect_to '/home/tools', :info => "Generated #{@rooms.count} tickets"
		end
	end

    def csv
        count = 0
        final = nil
        errors = []
        params[:pairs].each_line do |line|
            line.chomp!
            x = line.split(',')
            asset = Asset.where(:tag => x[0]).first
            t = Ticket.create(:room_id => room.id, :comment => x[1], :submitter_id => current_user, :ticketqueue_id => params[:ticketqueue_id], :status => params[:status], :due_at => params[:due_at], :asset => asset, :room => asset.room)
            if t.save
                count += 1
            else
                errors += t.errors.full_messages.map{|m| "#{asset.tag}: #{m}"}
            end
        end

        n = "Created #{count} tickets."
        if errors.count > 0
            n << "<br/>"
            errors.each do |e|
                n << e << "<br/>"
            end
        end

        redirect_to root_path, :notice => n.html_safe
    end

	def screenshot
		@ticket = Ticket.find(params[:id])
		redirect_to @ticket.attachment.url
	end

	def assign
		@ticket = Ticket.find(params[:id])
		@user = params[:user_id] ? User.find(params[:user_id]) : current_user
		unless @user.mission_tickets.include?(@ticket)
			Mission.create(:user => @user, :ticket => @ticket) 
			@ticket.users << @user unless @ticket.users.include?(@user)
		end
		respond_to do |format|
			format.html {redirect_to @ticket, :notice => "Assigned user to ticket."}
			format.js {}
		end
	end

	def unassign
		@ticket = Ticket.find(params[:id])
		@user = params[:user_id] ? User.find(params[:user_id]) : current_user
		if @user.mission_tickets.include?(@ticket)
			Mission.where(:user_id => @user.id, :ticket_id => @ticket.id).each {|m| m.delete}
		end
		
		respond_to do |format|
			format.html {redirect_to @ticket, :notice => "Unassigned user."}
			format.js {}
		end
	end
end
