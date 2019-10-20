require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup data doesn't create record" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '',
                                          email: 'inv@lid',
                                          password: 'foo',
                                          password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    assert_select 'form[action="/signup"]'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  test 'valid signup & activation creates record, logs in, redirects to show' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'ex@mp.le',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    refute user.activated?
    # Try to log in before activation
    log_in_as user
    assert flash[:warning]
    assert_response :redirect
    refute logged_in?
    # Try submitting invalid activation token
    get edit_account_activation_path('invalid token', email: user.email)
    refute logged_in?
    # Try activating with wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    refute logged_in?
    # Legitimate activation
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert logged_in?
  end
end
