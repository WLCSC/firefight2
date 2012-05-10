class ModelsController < ApplicationController
	before_filter :check_for_admin, :only => ['new', 'edit', 'create', 'update', 'destroy']
  # GET /models
  # GET /models.json
  def index
    @models = Model.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @models }
    end
  end

  # GET /models/1
  # GET /models/1.json
  def show
    @model = Model.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @model }
    end
  end

  # GET /models/new
  # GET /models/new.json
  def new
    @model = Model.new
    if params[:manufacturer_id]
	@model.manufacturer_id = params[:manufacturer_id]
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @model }
    end
  end

  # GET /models/1/edit
  def edit
    @model = Model.find(params[:id])
  end

  # POST /models
  # POST /models.json
  def create
    @model = Model.new(params[:model])

    respond_to do |format|
      if @model.save
        format.html { redirect_to @model, notice: 'Model was successfully created.' }
        format.json { render json: @model, status: :created, location: @model }
      else
        format.html { render action: "new" }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /models/1
  # PUT /models/1.json
  def update
    @model = Model.find(params[:id])

    respond_to do |format|
      if @model.update_attributes(params[:model])
        format.html { redirect_to @model, notice: 'Model was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /models/1
  # DELETE /models/1.json
  def destroy
    @model = Model.find(params[:id])
    @model.destroy

    respond_to do |format|
      format.html { redirect_to models_url }
      format.json { head :no_content }
    end
  end
end
