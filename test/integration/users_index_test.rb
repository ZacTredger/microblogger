require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:FirstUser)
    @non_admin = users(:SecondUser)
  end

  test 'index includes pagination & has delete links (except self) for admin' do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    User.paginate(page: 1).each do |user|
      path = user_path(user)
      assert_select 'a[href=?]', path, text: user.name
      assert_select 'a[href=?]', path, text: 'delete' unless user == @admin
    end
  end

  test 'index has no delete links when user is not admin' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test 'admin can delete user' do
    log_in_as(@admin)
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
end
