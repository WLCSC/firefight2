class HomeController < ApplicationController
	before_filter :check_for_admin, :only => ['tools']
  def index
	  @building = current_user.building if current_user
  end

  def tools
  end
end
