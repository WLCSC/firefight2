require 'auth.rb'

class SessionsController < ApplicationController
	skip_before_filter :check_for_user, :only => ['new', 'create']
	def new
		redirect_to :controller => 'home', :action => 'index' if current_user
	end

	def create
		lgi = ldap_login(params[:username], params[:password])
		if lgi && lgi.length > 0
			user = User.find_by_username(params[:username])
			user = ldap_populate(params[:username], params[:password], user)
			session[:user_id] = user.id
			flash[:notice] = "Logged in!"
			if user.building
				redirect_to params[:return] || root_path 
			else
				flash[:notice] = "Please indicate which building you belong to & make sure your information is correct in the form below."
				redirect_to edit_user_path(user)
			end
			
		else
			flash[:alert] = "Invalid login."
			redirect_to sessions_new_path
		end
	end

	def destroy
		session[:user_id] = nil  
		redirect_to root_url, :notice => "Logged out!"  
	end
end
