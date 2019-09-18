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
end
