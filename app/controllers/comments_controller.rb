class CommentsController < ApplicationController
	before_filter :check_for_admin, :only => [:update]
	# GET /comments/1/edit
	def edit
		@comment = Comment.find(params[:id])
		unless current_user.admin? || @comment.user == current_user
			redirect_to root_path, :notice => "You don't have permission to do that." 
		end
	end

	# POST /comments
	# POST /comments.json
	def create
		@comment = Comment.new(params[:comment])
		unless current_user.ticketqueues.include?(@comment.ticket.ticketqueue) || current_user.admin? || @comment.ticket.users.include?(current_user)
			redirect_to root_path, :notice => "You don't have permission to comment on that." 
		else
		if @comment.content != ""
			if params[:commit] == "Add Comment & Mark As Complete"
				@comment.ticket.status = 100
				@comment.ticket.save
			end
		else
			@comment.errors.add :content,  "can't be blank"
		end

		respond_to do |format|
			if @comment.save
				unless @comment.ticket.users.include? @comment.user
					@comment.ticket.users << @comment.user
				end

				notifications = []
				@comment.ticket.users.each {|u| notifications << u}
				@comment.ticket.room.building.techs.each {|u| notifications << u if @comment.ticket.ticketqueue.can?(u, :see)}
				@comment.ticket.asset.building.shortcuts.map{|s| s.user}.each {|u| notifications << u if @comment.ticket.ticketqueue.can?(u, :see)}
				@comment.ticket.asset.room.shortcuts.map{|s| s.user}.each {|u| notifications << u if @comment.ticket.ticketqueue.can?(u, :see)}
				@comment.ticket.submitter.shortcuts.map{|s| s.user}.each {|u| notifications << u if @comment.ticket.ticketqueue.can?(u, :see)}
				@comment.ticket.ticketqueue.shortcuts.map{|s| s.user}.each {|u| notifications << u if @comment.ticket.ticketqueue.can?(u, :see)}
				notifications.uniq!

				notifications.each do |u|
					begin
					MailMan.ticket_updated(@comment.ticket.id, u.id).deliver
					rescue => exc
						ExceptionNotifier::Notifier.exception_notification(request.env, exc, :data => {:message => "failed to deliver mail"}).deliver
					end
				end
				format.html { redirect_to @comment.ticket, notice: 'Comment was successfully created.' }
				format.json { render json: @comment, status: :created, location: @comment }
				format.js {}
			else
				format.html { redirect_to @comment.ticket }
				format.json { render json: @comment.errors, status: :unprocessable_entity }
				format.js { render js: '$("#flashbox").append(\'<div class="alert alert-warning"><button type="button" class="close" data-dismiss="alert">&times</button>That\'s not going to work.</div>\');'}
			end
		end
		end
	end

	# PUT /comments/1
	# PUT /comments/1.json
	def update
		@comment = Comment.find(params[:id])

		respond_to do |format|
			if @comment.update_attributes(params[:comment])
				format.html { redirect_to @comment.ticket, notice: 'Comment was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @comment.errors, status: :unprocessable_entity }
			end
		end
	end

end
