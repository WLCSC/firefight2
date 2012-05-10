class HomeController < ApplicationController
	skip_before_filter :check_for_user, :only => ['index']
	before_filter :check_for_admin, :only => ['tools']
  def index
	  redirect_to '/sessions/new' unless current_user
	  @building = current_user.building if current_user
  end

  def tools
  end
end
