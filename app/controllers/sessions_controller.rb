require 'auth.rb'

class SessionsController < ApplicationController
	skip_before_filter :check_for_user, :only => ['new', 'create']
	def new
		redirect_to :controller => 'home', :action => 'index' if current_user
	end

	def create
		params[:username].downcase!
		user = User.where(:username => params[:username]).first
		n = nil
		if APP_CONFIG[:auth_ldap] && user.password_hash == nil
			lgi = ldap_login(params[:username], params[:password])
			if lgi && lgi.length > 0
				user = ldap_populate(params[:username], params[:password], user)
				session[:user_id] = user.id
				n = "Logged in!"
			else
				n = "Invalid login."
			end
		end
		if APP_CONFIG[:auth_local] && user && user.password_hash != nil
			if user.password_hash == BCrypt::Engine.hash_secret(params[:password], user.password_salt)
				session[:user_id] = user.id
				n = "Logged in!"
			else
				n = "Invalid local login."
			end
		end
		redirect_to root_path, :notice => n
	end

	def destroy
		session[:user_id] = nil  
		redirect_to root_url, :notice => "Logged out!"  
	end
end
