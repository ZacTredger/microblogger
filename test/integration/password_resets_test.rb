require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users.first
  end

  test 'resets password if requested and valid' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path, params: { password_reset: { email: '' }}
    refute flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    refute_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    refute flash.empty?
    assert_redirected_to root_url
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Right email; wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email; right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    # Non-matching password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: 'foobarbaz',
                            password_confirmation: 'bazbarfoo' } }
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: '',
                            password_confirmation: '' } }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: 'foobarbaz',
                            password_confirmation: 'foobarbaz' } }
    assert logged_in?
    refute flash.empty?
    assert_redirected_to user
    assert_nil user.reload.reset_digest
  end

  test 'redirects if reset token expired' do
    get new_password_reset_path
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password: 'foobarbaz',
                            password_confirmation: 'foobarbaz' } }
    assert_response :redirect
    follow_redirect!
    assert_match(/expire/i, response.body)
  end
end
