class LoginController < ApplicationController
  # This is the initial landing page and forces the user to log in to the application
  # It could be a route called Login but I like to stay with the basic http calls
  # So we will instantiate a Service object with the data from this POST and
  # then call the LANSA INTEGRATOR function to validate the user
  # if they're valid we'll instantiate a PortalUser Object and redirect
  # to the landing page
  def new
    @login_user = LoginUser.new
  end

  def create
    @login_user = LoginUser.new(params['login_user'])
    if @login_user.login?
      log_in(@login_user)
      redirect_back_or portal_user_path()
    else
      flash.now[:error] = 'Please provide a valid email address or password'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
