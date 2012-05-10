class ManufacturersController < ApplicationController
	before_filter :check_for_admin, :only => ['new', 'edit', 'create', 'update', 'destroy']
  # GET /manufacturers
  # GET /manufacturers.json
  def index
    @manufacturers = Manufacturer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @manufacturers }
    end
  end

  # GET /manufacturers/1
  # GET /manufacturers/1.json
  def show
    @manufacturer = Manufacturer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manufacturer }
    end
  end

  # GET /manufacturers/new
  # GET /manufacturers/new.json
  def new
    @manufacturer = Manufacturer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manufacturer }
    end
  end

  # GET /manufacturers/1/edit
  def edit
    @manufacturer = Manufacturer.find(params[:id])
  end

  # POST /manufacturers
  # POST /manufacturers.json
  def create
    @manufacturer = Manufacturer.new(params[:manufacturer])

    respond_to do |format|
      if @manufacturer.save
        format.html { redirect_to @manufacturer, notice: 'Manufacturer was successfully created.' }
        format.json { render json: @manufacturer, status: :created, location: @manufacturer }
      else
        format.html { render action: "new" }
        format.json { render json: @manufacturer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manufacturers/1
  # PUT /manufacturers/1.json
  def update
    @manufacturer = Manufacturer.find(params[:id])

    respond_to do |format|
      if @manufacturer.update_attributes(params[:manufacturer])
        format.html { redirect_to @manufacturer, notice: 'Manufacturer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manufacturer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manufacturers/1
  # DELETE /manufacturers/1.json
  def destroy
    @manufacturer = Manufacturer.find(params[:id])
    @manufacturer.destroy

    respond_to do |format|
      format.html { redirect_to manufacturers_url }
      format.json { head :no_content }
    end
  end
end
