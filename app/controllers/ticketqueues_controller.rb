class TicketqueuesController < ApplicationController
	before_filter :check_for_admin, :only => ['new', 'edit', 'create', 'update', 'destroy']
  # GET /ticketqueues
  # GET /ticketqueues.json
  def index
    @ticketqueues = current_user.queues

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ticketqueues }
    end
  end

  # GET /ticketqueues/1
  # GET /ticketqueues/1.json
  def show
    @ticketqueue = Ticketqueue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ticketqueue }
    end
  end

  # GET /ticketqueues/new
  # GET /ticketqueues/new.json
  def new
    @ticketqueue = Ticketqueue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ticketqueue }
    end
  end

  # GET /ticketqueues/1/edit
  def edit
    @ticketqueue = Ticketqueue.find(params[:id])
  end

  # POST /ticketqueues
  # POST /ticketqueues.json
  def create
    @ticketqueue = Ticketqueue.new(params[:ticketqueue])

    respond_to do |format|
      if @ticketqueue.save
        format.html { redirect_to @ticketqueue, notice: 'Ticketqueue was successfully created.' }
        format.json { render json: @ticketqueue, status: :created, location: @ticketqueue }
      else
        format.html { render action: "new" }
        format.json { render json: @ticketqueue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ticketqueues/1
  # PUT /ticketqueues/1.json
  def update
    @ticketqueue = Ticketqueue.find(params[:id])

    respond_to do |format|
      if @ticketqueue.update_attributes(params[:ticketqueue])
        format.html { redirect_to @ticketqueue, notice: 'Ticketqueue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ticketqueue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ticketqueues/1
  # DELETE /ticketqueues/1.json
  def destroy
    @ticketqueue = Ticketqueue.find(params[:id])
    @ticketqueue.destroy

    respond_to do |format|
      format.html { redirect_to ticketqueues_url }
      format.json { head :no_content }
    end
  end
end
