require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:FirstUser)
    @content = 'lorem ipsum'
  end

  test 'redirect create if user not logged in' do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: @content } }
    end
    assert_redirected_to login_path
  end

  test 'redirect delete if user not logged in' do
    assert_no_difference 'Post.count' do
      delete post_path(Post.last.id)
    end
    assert_redirected_to login_path
  end

  test 'user can create post and delete their own post' do
    log_in_as(@user)
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: @content } }
    end
    assert_response :redirect
    assert_difference 'Post.count', -1 do
      delete post_path(Post.find_by(user_id: @user.id, content: @content))
    end
  end

  test "user can't delete the post of another user" do
    log_in_as(@user)
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: @content } }
    end
    assert_response :redirect
    log_in_as(users(:SecondUser))
    assert_no_difference 'Post.count' do
      delete post_path(Post.find_by(user_id: @user.id, content: @content))
    end
    assert_response :redirect
  end
end
