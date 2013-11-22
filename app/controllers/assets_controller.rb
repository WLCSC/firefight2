class AssetsController < ApplicationController
	before_filter :check_for_support, :only => ['new', 'edit', 'create', 'update']
	before_filter :check_for_admin, :only => ['destroy']
	# GET /assets
	# GET /assets.json
	def index
        @assets = []
		if params[:serial] || params[:building_id] || params[:type_id]
			@assets = Asset.where(true)
			if params[:serial] && !params[:serial].empty?
				@assets = @assets.where("serial LIKE ?", "%#{params[:serial]}%")
			end
			if params[:building_id] && !params[:building_id].empty?
				@assets = @assets.where(:room_id => Building.find(params[:building_id]).room_ids)
			end
			if params[:type_id] && !params[:type_id].empty?
				@assets = @assets.where(:model_id => Rtype.find(params[:type_id]).model_ids)
			end
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
				format.html { redirect_to @asset, notice: 'Asset was successfully updated.' }
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
		@collection = []
		@collection += Asset.where(:tag => params[:tag][0]).all
		@collection += User.where('name LIKE ?', "%#{params[:tag][0]}%").all
		@collection += Room.where('name LIKE ?', "%#{params[:tag][0]}%").all
		@collection += Asset.where('serial LIKE ?', "%#{params[:tag][0]}%").all
		@collection += Ticket.where('id LIKE ?', "%#{params[:tag][0]}%").all
	
		if @collection.length == 0
			redirect_to root_path, :notice => "Couldn't find anything like that."
		elsif @collection.length == 1
			redirect_to @collection.first
		else
			
		end
	end

	def move
		r = params[:room_name].split(' - ')
		@room = Room.where(:name => r[1]).where(:building_id => Building.where(:name => r[0]).first.id).first
        @params = {}
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
        @params[:bad] = bad
		if bad.length == 0
			flash.now[:notice] = "Moved assets."
            @tags = ''
		else
            alert = "#{bad.length} bad tags were submitted: #{bad.join}"
            flash.now[:alert] = alert
            @tags = params[:tags]
		end
		render 'home/tools'
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
			asset.tag = x[0].chomp
			asset.serial = x[1].chomp
            asset.name = x[2].chomp if x[2]
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
