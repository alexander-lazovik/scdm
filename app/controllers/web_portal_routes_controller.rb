class WebPortalRoutesController < ApplicationController
  before_action :logged_in_user
  before_action :set_portal_route, only: [:show, :rdl]

  def show
  end

  def rdl
  end

  private
    def set_portal_route
      @web_portal_route = WebPortalRoute.find(params[:id])
    end
end
