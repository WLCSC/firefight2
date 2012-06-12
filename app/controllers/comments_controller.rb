class CommentsController < ApplicationController
	# GET /comments/1/edit
	def edit
		@comment = Comment.find(params[:id])
	end

	# POST /comments
	# POST /comments.json
	def create
		@comment = Comment.new(params[:comment])
		if @comment.content != ""
			if params[:commit] == "Add Comment & Mark As Complete"
				@comment.ticket.status = 100
				@comment.ticket.save
			end
		else
 		        flash[:error] = "You can't add blank comments."
			@comment.errors.add :content,  "can't be blank"
		end
		respond_to do |format|
			if @comment.save
				unless @comment.ticket.users.include? @comment.user
					@comment.ticket.users << @comment.user
				end
				@comment.ticket.users.each do |u|
					MailMan.ticket_updated(@comment.ticket, u).deliver
				end
				format.html { redirect_to @comment.ticket, notice: 'Comment was successfully created.' }
				format.json { render json: @comment, status: :created, location: @comment }
			else
				format.html { redirect_to @comment.ticket }
				format.json { render json: @comment.errors, status: :unprocessable_entity }
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
