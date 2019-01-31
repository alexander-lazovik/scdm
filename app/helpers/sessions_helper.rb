module SessionsHelper

  # Returns the portal user object corresponding to the sessid from the session hash.
  def current_user
    if (sessid = session[:sessid])
      @current_user ||= PortalUser.find(sessid)
    end
  end
  
  # Logs in the given user.
  def log_in(user)
    session[:sessid] = user.session_id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    cookies.permanent.signed[:sessid] = user.session_id
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget(user)
#    delete the portal user session from database
#    user.forget 
    cookies.delete(:sessid)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:sessid)
    @current_user = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
