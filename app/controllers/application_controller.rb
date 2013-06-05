class ApplicationController < ActionController::Base
	protect_from_forgery

	before_filter :grab_url
	before_filter :check_for_user

	private
	def current_user  
		@current_user ||= User.find(session[:user_id]) if session[:user_id]  
		@current_user
	end

	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

	def check_for_user
		redirect_to sessions_new_path(:return => request.original_url) unless current_user
	end

	def check_for_admin
	unless current_user && current_user.admin?
		flash[:alert] = "You aren't authorized to do that."
		redirect_to root_path 	
	end
	end

	def check_for_support
	unless current_user && current_user.support
		flash[:alert] = "You aren't authorized to do that."
		redirect_to root_path 	
	end
	end

	def grab_url
		@url = request.original_url
	end
end
