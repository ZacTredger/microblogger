require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:FirstUser)
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

  test 'redirects to login page when edit page requested without log-in' do
    get edit_user_path(@user)
    refute flash.empty?
    assert_redirected_to login_path
  end

  test 'redirects to login page when user-update requested without log-in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    refute flash.empty?
    assert_redirected_to login_path
  end
end
