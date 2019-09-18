require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:FirstUser)
    @other_user = users(:SecondUser)
  end

  test 'redirects to login when not logged-in but then continues after login' do
    get edit_user_path(@user)
    refute flash.empty?
    assert_redirected_to login_path
    log_in_as @user
    assert_redirected_to edit_user_path(@user)
    refute session[:forwarding_url]
  end

  test 'rejects invalid details and re-renders edit page' do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'invalid_em@il',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }
    assert_template 'users/edit'
    assert_select 'div.alert'
  end

  test 'accepts valid details and updates database' do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '' } }
    refute flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test 'redirects to login page when user-update requested without log-in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    refute flash.empty?
    assert_redirected_to login_path
  end

  test 'redirects to root when one user requests edit-page of another' do
    log_in_as @user
    get edit_user_path(@other_user)
    refute flash.empty?
    assert_redirected_to root_url
  end

  test "redirects to root when one user tries to update another's profile" do
    log_in_as @user
    patch user_path(@other_user)
    refute flash.empty?
    assert_redirected_to root_url
  end
end
