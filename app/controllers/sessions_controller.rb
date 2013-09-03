require 'auth.rb'

class SessionsController < ApplicationController
	skip_before_filter :check_for_user, :only => ['new', 'create']
	def new
		redirect_to :controller => 'home', :action => 'index' if current_user
	end


	def create
         params[:username].downcase!
	 ok = false
         user = User.where(:username => params[:username]).first
         if APP_CONFIG[:auth_ldap] && (!user || (user && user.password_hash == nil))
             lgi = ldap_login(params[:username], params[:password])
             if lgi && lgi.length > 0
                 user = ldap_populate(params[:username], params[:password], user)
                 session[:user_id] = user.id
                 flash[:notice] = "Logged in!"
		 ok = true
             else
                 flash[:alert] = "Invalid login."
             end
         elsif APP_CONFIG[:auth_local] && user && user.email_address != nil
             if user.password_hash == BCrypt::Engine.hash_secret(params[:password], user.password_salt)
                 session[:user_id] = user.id
                 flash[:notice] = "Logged in!"
                 ok = true
             else
                 flash[:alert] = "Invalid local login."

             end
         else
             flash[:alert] = "You are not allowed to log in."
         end

        if ok 
		if user.buildings.count == 0
			redirect_to edit_user_path(user), :notice => 'Please indicate which building(s) you belong to & make sure the rest of your information is correct.'
		else
			redirect_to params[:return] || root_path
		end
	else
		redirect_to root_path
	end
     end


	def destroy
		session[:user_id] = nil  
		redirect_to root_url, :notice => "Logged out!"  
	end
end
