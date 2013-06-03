class AssetsController < ApplicationController
	before_filter :check_for_admin, :only => ['new', 'edit', 'create', 'update', 'destroy']
	# GET /assets
	# GET /assets.json
	def index
		if params[:serial] || params[:building_id]
			@assets = Asset.where(true)
			if params[:serial]
				@assets = @assets.where("serial LIKE ?", "%#{params[:serial]}%")
			end
			if params[:building_id]
				@assets = @assets.where(:room_id => Building.find(params[:building_id]).room_ids)
			end
			if params[:type_id]
				@assets = @assets.where(:model_id => Rtype.find(params[:type_id]).model_ids)
			end
		else
			@assets = []
		end

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @assets }
		end
	end

	# GET /assets/1
	# GET /assets/1.json
	def show
		@asset = Asset.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @asset }
		end
	end

	# GET /assets/new
	# GET /assets/new.json
	def new
		@asset = Asset.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @asset }
		end
	end

	# GET /assets/1/edit
	def edit
		@asset = Asset.find(params[:id])
	end

	# POST /assets
	# POST /assets.json
	def create
		@asset = Asset.new(params[:asset])

		respond_to do |format|
			if @asset.save
				format.html { redirect_to @asset, notice: 'Asset was successfully created.' }
				format.json { render json: @asset, status: :created, location: @asset }
			else
				format.html { render action: "new" }
				format.json { render json: @asset.errors, status: :unprocessable_entity }
			end
		end
	end

	# put /assets/1
	# put /assets/1.json
	def update
		@asset = Asset.find(params[:id])

		respond_to do |format|
			if @asset.update_attributes(params[:asset])
				format.html { redirect_to @asset, notice: 'asset was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @asset.errors, status: :unprocessable_entity }
			end
		end
	end

	# delete /assets/1
	# delete /assets/1.json
	def destroy
		@asset = Asset.find(params[:id])
		@asset.destroy

		respond_to do |format|
			format.html { redirect_to assets_url }
			format.json { head :no_content }
		end
	end

	def quick
		@tag = Asset.where(:tag => params[:tag]).first
		if @tag
			flash[:notice] = "found asset."
			redirect_to @tag, :notice => "found asset."
		else
			flash[:alert] = "can't find asset."
			redirect_to params[:return], :notice => "can't find asset"
		end
	end

	def move
		r = params[:room_name].split(' - ')
		@room = Room.where(:name => r[1]).where(:building_id => Building.where(:name => r[0]).first.id).first
		bad = []
		params[:tags].each_line do |t|
			a = Asset.where(:tag => t.chomp).first
			if a
				a.room = @room
				a.save
			else
				bad << t.chomp
			end
		end
		if bad.length == 0
			redirect_to home_tools_path(:t => 'move'), :notice => 'moved assets.'
		else
			redirect_to home_tools_path(:t => 'move'), :notice => "#{bad.length} bad tags were submitted: #{bad.join}"
		end
	end

	def mass
		count = 0
		final = nil
		errors = []
		r = params[:room_name].split(' - ')
		room = Room.where(:name => r[1]).where(:building_id => Building.where(:name => r[0]).first.id).first
		params[:pairs].each_line do |line|
			line.chomp!
			asset = Asset.create(:super => false, :name => "")
			asset.room_name = params[:room_name]
			asset.os = params[:os]
			asset.model_name = params[:model_name]
			asset.purchase_date = params[:purchase_date]
			asset.cost = params[:cost]
			asset.vendor_id = params[:vendor_id]
			asset.notes = params[:notes]
			x = line.split(',')
			asset.tag = x[0]
			asset.serial = x[1]
			if asset.save
				count += 1
			else
				errors += asset.errors.full_messages.map{|m| "#{asset.tag}: #{m}"}
			end
		end

			n = "Created #{count} assets."
			if errors.count > 0
				n << "<br/>"
				errors.each do |e|
					n << e << "<br/>"
				end
			end
			redirect_to room, :notice => n.html_safe
	end
end
