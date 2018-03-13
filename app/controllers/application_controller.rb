class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :sign_in?

  def sign_in(user)
    session[:session_token] = user.reset_session_token!
  end
  
  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def sign_in?
    !!current_user
  end

  def sign_out
    current_user.try(:reset_session_token!)
    session[:session_token] = nil
  end

  def require_sign_in
    redirect_to new_session_url unless sign_in?
  end
end
