class SessionsController < ApplicationController
  def new; end

  def create
    session_params = whitelist_session_params
    @user = User.find_by(email: session_params[:email].downcase)
    if @user&.authenticate(session_params[:password])
      accept_user session_params
    else
      reject_user
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def whitelist_session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
