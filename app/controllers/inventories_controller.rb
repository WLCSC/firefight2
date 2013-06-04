class InventoriesController < ApplicationController
	before_filter :check_for_admin, :except => [:use]
	before_filter :check_for_user
  # POST /inventories
  # POST /inventories.json
  def create
    @inventory = Inventory.where(:room_id => params[:room_id], :consumable_id => params[:consumable_id]).first_or_initialize(:count => 0)
		@inventory.count += params[:count].to_i
		if @inventory.save
			flash[:notice] = "Updated inventory"
		else
			flash[:error] = "Invalid inventory operation."
		end

		@inventory.consumable.alerts.where(:building_id => @inventory.room.building.id).where("count >= ?", @inventory.room.building.consumable_count(@inventory.consumable)).each do |a|
			MailMan.consumable_alert(a.id).deliver
		end

		@inventory.consumable.alerts.where(:building_id => nil).where("count >= ?", @inventory.consumable.total_count).each do |a|
			MailMan.consumable_alert(a.id).deliver
		end

		redirect_to @inventory.room
	end

	def adj
		@inventory = Inventory.find(params[:id])
		if params[:commit] == "+"
			@inventory.count += 1
		elsif params[:commit] == "-"
			@inventory.count -= 1
		end

		@inventory.consumable.alerts.where(:building_id => @inventory.room.building.id).where("count >= ?", @inventory.room.building.consumable_count(@inventory.consumable)).each do |a|
			MailMan.consumable_alert(a.id).deliver
		end

		@inventory.consumable.alerts.where(:building_id => nil).where("count >= ?", @inventory.consumable.total_count).each do |a|
			MailMan.consumable_alert(a.id).deliver
		end

		@inventory.save
	end

	def use
		r = params[:room_name].split(' - ')
		@use = Use.new(:consumable_id => params[:consumable_id], :count => params[:count], :room_id => params[:room_id])	
		@from = Room.where(:name => r[1]).where(:building_id => Building.where(:name => r[0]).first.id).first
		@inventory = @from.inventories.where(:consumable_id => params[:consumable_id]).first
		if @inventory && @inventory.count > 0 && @use.save
			@inventory.count -= @use.count
			if @inventory.save
				redirect_to @use.room, :notice => "Used #{@use.consumable.name}."
			else
				redirect_to @use.room, :notice => "Something wasn't quite right there."
			end
		else
			redirect_to @use.room, :notice => 'Something wasn\'t quite right there.'
		end
	end
end
