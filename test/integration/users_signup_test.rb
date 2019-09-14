require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  test 'valid signup data creates record' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'Example User',
                                          email: 'ex@mp.le',
                                          password: 'password1',
                                          password_confirmation: 'password1' } }
    end
    follow_redirect!
    assert_template 'users/show'
    refute flash.blank?
  end
end
