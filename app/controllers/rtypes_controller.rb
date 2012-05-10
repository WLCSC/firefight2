class RtypesController < ApplicationController
	before_filter :check_for_admin, :only => ['new', 'edit', 'create', 'update', 'destroy']
  # GET /rtypes
  # GET /rtypes.json
  def index
    @rtypes = Rtype.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rtypes }
    end
  end

  # GET /rtypes/1
  # GET /rtypes/1.json
  def show
    @rtype = Rtype.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rtype }
    end
  end

  # GET /rtypes/new
  # GET /rtypes/new.json
  def new
    @rtype = Rtype.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rtype }
    end
  end

  # GET /rtypes/1/edit
  def edit
    @rtype = Rtype.find(params[:id])
  end

  # POST /rtypes
  # POST /rtypes.json
  def create
    @rtype = Rtype.new(params[:rtype])

    respond_to do |format|
      if @rtype.save
        format.html { redirect_to @rtype, notice: 'Rtype was successfully created.' }
        format.json { render json: @rtype, status: :created, location: @rtype }
      else
        format.html { render action: "new" }
        format.json { render json: @rtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rtypes/1
  # PUT /rtypes/1.json
  def update
    @rtype = Rtype.find(params[:id])

    respond_to do |format|
      if @rtype.update_attributes(params[:rtype])
        format.html { redirect_to @rtype, notice: 'Rtype was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rtypes/1
  # DELETE /rtypes/1.json
  def destroy
    @rtype = Rtype.find(params[:id])
    @rtype.destroy

    respond_to do |format|
      format.html { redirect_to rtypes_url }
      format.json { head :no_content }
    end
  end
end
