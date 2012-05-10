class TicketsController < ApplicationController
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

    if params[:queue_id]
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ticket }
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
	@user = User.find(params[:user])
	if @ticket.users.include? @user
		@ticket.users.delete(@user)
	else
		@ticket.users << @user
	end
	redirect_to @ticket, info: "Tagged user."
  end
end
