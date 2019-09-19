require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:FirstUser)
    @other_user = users(:SecondUser)
  end

  test 'redirects to login page when index page requested without loggin in' do
    get users_path
    assert_redirected_to login_path
  end

  test 'redirects to root if page is of unactivated user' do
    get user_path(User.find_by(activated: false))
    assert_redirected_to root_url
  end

  test "user can't patch themself admin rights" do
    log_in_as(@other_user)
    refute @other_user.admin?, 'test must be run on non-admin user'
    patch user_path(@other_user),
          params: { user: { name: @other_user.name,
                            email: @other_user.email,
                            password: 'password',
                            password_confirmation: 'password',
                            admin: true } }
    refute @other_user.reload.admin?
  end

  test 'redirects destroy to login page when user is not logged-in' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    refute flash.empty?
    assert_redirected_to login_path
  end

  test 'redirects destroy to root when user is not an admin' do
    log_in_as @other_user
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    refute flash.empty?
    assert_redirected_to root_url
  end
end
