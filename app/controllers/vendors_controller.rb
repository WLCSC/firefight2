class VendorsController < ApplicationController
	before_filter :check_for_admin, :only => ['new', 'edit', 'create', 'update', 'destroy']
  # GET /vendors
  # GET /vendors.json
  def index
    @vendors = Vendor.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vendors }
    end
  end

  # GET /vendors/1
  # GET /vendors/1.json
  def show
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vendor }
    end
  end

  # GET /vendors/new
  # GET /vendors/new.json
  def new
    @vendor = Vendor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vendor }
    end
  end

  # GET /vendors/1/edit
  def edit
    @vendor = Vendor.find(params[:id])
  end

  # POST /vendors
  # POST /vendors.json
  def create
    @vendor = Vendor.new(params[:vendor])

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to @vendor, notice: 'Vendor was successfully created.' }
        format.json { render json: @vendor, status: :created, location: @vendor }
      else
        format.html { render action: "new" }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vendors/1
  # PUT /vendors/1.json
  def update
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      if @vendor.update_attributes(params[:vendor])
        format.html { redirect_to @vendor, notice: 'Vendor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendors/1
  # DELETE /vendors/1.json
  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy

    respond_to do |format|
      format.html { redirect_to vendors_url }
      format.json { head :no_content }
    end
  end
end
