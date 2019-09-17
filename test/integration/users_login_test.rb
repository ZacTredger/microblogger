require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:User1)
  end

  test 'Rejects invalid login with unregistered email and flashes once' do
    get login_path
    assert_select 'form[action="/login"]'
    post login_path, params: { session: { email: '',
                                          password: '' } }
    assert_select 'form[action="/login"]'
    assert_select 'div.alert'
    get login_path
    assert_select 'div.alert', false
  end

  test 'Rejects incorrect password and displays login in header' do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'not_password' } }
    assert_select 'form[action="/login"]'
    assert_select 'div.alert'
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, false
    assert_select 'a[href=?]', user_path(@user), false
  end

  test "Accepts valid login info, redirects to user's page, then logs out" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, false
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', logout_path
    delete logout_path
    refute logged_in?
    assert_redirected_to root_url
    # Simulate user clicking logout in a second window, also running app
    delete logout_path
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, false
    assert_select 'a[href=?]', user_path(@user), false
  end

  test 'Login in with remembering... remembers' do
    log_in_as @user
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test "Login without remembering doesn't remember" do
    # Log in to set cookie
    log_in_as @user
    # Log in again without remembering, to check cookie is deleted
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end
end
