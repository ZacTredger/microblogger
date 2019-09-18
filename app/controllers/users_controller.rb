class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update index]
  before_action :correct_user, only: %i[edit update]
  def index
    @users = User.all
  end

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
    @user = User.find(params[:id])
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

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_path
  end

  # Confirms the logged-in user is the same as the user whose page it is
  def correct_user
    return if current_user?(User.find(params[:id]))

    flash[:danger] = 'You were not authorized to access that page.'
    redirect_to root_url
  end
end
