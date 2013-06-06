class HomeController < ApplicationController
	before_filter :check_for_support, :only => ['tools']
  def index
	  @building = current_user.building if current_user
  end

  def tools
  end
end
