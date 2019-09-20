class PasswordResetsController < ApplicationController
  before_action :find_user, only: %i[edit update]
  before_action :validate_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    unless @user
      flash.now[:danger] = 'Email address not found'
      return (render :new)
    end
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = 'Email sent with password reset instructions'
    redirect_to root_url
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = 'We have reset your password.'
      return (redirect_to @user)
    end
    render :edit
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Before-filters
  # Finds a user by the email in params
  def find_user
    @user = User.find_by(email: params[:email].downcase)
  end

  # Confirms user is activated and authenticated
  def validate_user
    return if @user&.activated? && @user.authenticated?(params[:id], :reset)

    redirect_to root_url
  end

  # Checks whether password reset token has expired
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'Password reset link has expired.'
    redirect_to new_password_reset_url
  end
end
