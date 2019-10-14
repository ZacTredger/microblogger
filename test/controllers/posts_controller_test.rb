require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:FirstUser)
  end

  test 'redirect create if user not logged in' do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: 'lorem ipsum' } }
    end
    assert_redirected_to login_path
  end

  test 'redirect delete if user not logged in' do
    assert_no_difference 'Post.count' do
      delete post_path(Post.last.id)
    end
    assert_redirected_to login_path
  end
end
