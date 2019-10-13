require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  setup do
    @user = users(:FirstUser)
  end

  test 'displays profile' do
    get user_path(@user)
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name { |h| assert_select h, 'img.gravatar' }
    assert_match @user.posts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.posts.paginate(page: 1).each do |post|
      assert_match post.content, response.body
    end
  end
end
