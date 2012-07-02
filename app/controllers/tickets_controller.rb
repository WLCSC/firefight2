class TicketsController < ApplicationController
	include ApplicationHelper
	before_filter :check_for_admin, :only => ['destroy']
	# GET /tickets
	# GET /tickets.json
	def index
		if params[:status]
			case params[:status]
			when 'a'
				@tickets = Ticket.where(:status => [1,2,3,99,100])
			when 'i'
				@tickets = Ticket.where(:status => [1,2,3,99])
			when 'c'
				@tickets = Ticket.where(:status => 100)
			end
		else
			@tickets = Ticket.where(:status => [1,2,3,99])
		end

		if params[:queue_id] != ""
			@tickets= @tickets.where(:ticketqueue_id => params[:queue_id])
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
		unless current_user.ticketqueues.include?(@ticket.ticketqueue) || current_user.admin?
		redirect_to '/', :error => "You don't have permission to read that." 
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
	end

	# POST /tickets
	# POST /tickets.json
	def create
		@ticket = Ticket.new(params[:ticket])

		respond_to do |format|
			if @ticket.save
				MailMan.ticket_submitted(current_user, @ticket, @ticket.comments.first).deliver
				User.where(:administrator => true).each do |u|
					MailMan.tech_submitted(u, @ticket, @ticket.comments.first).deliver
				end
				format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
				format.json { render json: @ticket, status: :created, location: @ticket }
			else
				format.html { render action: "new" }
				format.json { render json: @ticket.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /tickets/1
	# PUT /tickets/1.json
	def update
		@ticket = Ticket.find(params[:id])

		respond_to do |format|
			if @ticket.update_attributes(params[:ticket])
				@ticket.users << current_users unless @ticket.users.include? current_user
				if params[:commit] = "OK"
					c = Comment.create!(:user_id => current_user.id, :ticket_id => @ticket.id, :content => "#{current_user.name} changed the status of this ticket to #{string_status(@ticket.status)}")
				end

				if @ticket.status == 100 && !@ticket.assigned?
					User.where(:administrator => :true).each do |u|
						MailMan.ticket_updated(@ticket,u)
					end
				end

				@ticket.users.each do |u|
					MailMan.ticket_updated(@ticket, u).deliver
				end

				format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @ticket.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /tickets/1
	# DELETE /tickets/1.json
	def destroy
		@ticket = Ticket.find(params[:id])
		@ticket.destroy

		respond_to do |format|
			format.html { redirect_to tickets_url }
			format.json { head :no_content }
		end
	end

	def tagchange
		@ticket = Ticket.find(params[:id])
		if params[:user]
			@user = User.find(params[:user])
		elsif params[:user_name]
			@user = User.where(:name => params[:user_name]).first
		else
			@user = current_user
		end
		if @ticket.users.include? @user
			@ticket.users.delete(@user)
		else
			@ticket.users << @user
		end
		redirect_to ticket_path(@ticket), info: "Tagged user."
	end

	def mass
		b = (params[:building_id] == '0' ? nil : Building.find(params[:building_id]))
		d = (params[:department_id] == 0 ? nil : Department.find(params[:department_id]))
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
			t = Ticket.create(:room_id => r, :comment => params[:comment], :submitter_id => params[:submitter_id], :ticketqueue_id => params[:ticketqueue_id], :status => params[:status], :due_at => params[:due_at], :asset_id => r.default_asset.id)
			t.save
		end

		redirect_to '/home/tools', :info => "Generated #{@rooms.count} tickets"
	end
end
