class MiscpagesController < ApplicationController
  def show
    render template: "miscpages/#{params[:id]}"
  end
end
