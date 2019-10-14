class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper

  # General purpose before-filters

  # Confirms the user is logged-in
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_path
  end

  # Confirms the logged-in user is the same as the user whose page it is
  def correct_user(user_id: params[:id])
    return if current_user?(User.find_by(id: user_id))

    flash[:danger] = 'You were not authorized to access that page.'
    redirect_to root_url
  end

  # Confirm user is an admin.
  def admin_user
    return if current_user.admin?

    flash[:danger] = 'You were not authorized to access that page.'
    redirect_to root_url
  end
end
