class AuditController < ApplicationController
    before_filter :check_for_admin
  def index
      @activities = PublicActivity::Activity.order("created_at DESC")
  end
end
