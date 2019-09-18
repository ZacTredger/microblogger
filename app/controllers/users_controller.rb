class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update]
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    return (render :new) unless @user.save

    log_in @user
    flash[:success] = 'Welcome to Microblogger!'
    redirect_to @user
  end

  def edit
    @user = User.find(params.permit(:id)[:id])
  end

  def update
    @user = User.find(params[:id])
    return (render :edit) unless @user&.update_attributes(user_params)

    flash[:success] = 'Profile updated'
    redirect_to @user
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end

  # Before-filters

  # Confirms the user is logged-in
  def logged_in_user
    return if logged_in?

    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end
end
