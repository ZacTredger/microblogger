module SessionsHelper
  # Credentials accepted; log in user, create session and redirect to user-page.
  def accept_user(remember_me)
    log_in @user
    remember_me == '1' ? remember(@user) : forget(@user)
    redirect_back_after_login
  end

  # Credentials rejected; (re-)render new and flash error.
  def reject_user
    flash.now[:danger] = 'Invalid email/password combination'
    render :new
  end

  # If user's account needs to be activated
  def remind_to_activate
    flash[:warning] = 'You need to activate your account. Check your email for'\
      ' the activation link.'
    redirect_to root_url
  end

  # Returns user ID. Pass a definite user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session
  def remember(user)
    user.remember
    permanent_cookies = cookies.permanent
    permanent_cookies.signed[:user_id] = user.id
    permanent_cookies[:remember_token] = user.remember_token
  end

  # Returns true if the given user is the logged-in user
  def current_user?(user)
    user == current_user
  end

  # Returns the current logged-in user (if any).
  def current_user
    user_id = session[:user_id]
    return session_user(user_id) if user_id

    return unless (user_id = cookies.signed[:user_id])

    user = User.find_by(id: user_id)
    cookie_user(user) if user&.authenticated?(cookies[:remember_token])
  end

  # Returns true if the user is logged in; false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out current user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to a default)
  def redirect_back_after_login(default: user_path(@user))
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL user is attempting to access
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  private

  def session_user(user_id)
    @current_user ||= User.find_by(id: user_id) if user_id
  end

  def cookie_user(user)
    log_in(user)
    @current_user = user
  end

  # Forget a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
