class SessionsController < ApplicationController
  def new; end

  def create
    session_params = params[:session]
    @user = User.find_by(email: session_params[:email].downcase)
    if @user&.authenticate(session_params[:password])
      return remind_to_activate unless @user.activated?

      accept_user session_params[:remember_me]
    else
      reject_user
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
