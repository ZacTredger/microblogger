require 'test_helper'

class PostsInterfaceTestTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:FirstUser)
    @other_user = users(:SecondUser)
    @post = posts(:orange)
    @content = 'lorem ipsum'
    @picture = %w[test/fixtures/kitten.jpg image/jpeg]
  end

  test 'invalid post attempts re-render and displays errors' do
    prepare_to_post
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: '' } }
    end
    assert_select 'form[action=?]', posts_path
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  test 'user can create post and delete their own post' do
    create_valid_post(assert: true)
    assert_difference 'Post.count', -1 do
      delete post_path(Post.find_by(user_id: @user.id, content: @content))
    end
  end

  test "user can't delete the post of another user" do
    create_valid_post
    log_in_as(@other_user)
    assert_no_difference 'Post.count' do
      delete post_path(Post.find_by(user_id: @user.id, content: @content))
    end
    assert_response :redirect
  end

  test 'deletion of non-existent post redirects safely' do
    assert_no_difference 'Post.count' do
      delete post_path(unused_post_id)
    end
    assert_response :redirect
  end

  test "can't see delete links for other user's posts" do
    log_in_as(@other_user)
    get user_path(@user)
    assert_select 'a', text: 'delete', count: 0
  end

  private

  def prepare_to_post
    log_in_as(@user)
    get root_path
  end

  def create_valid_post(assert: false)
    prepare_to_post
    assert ? assert_post_post : post_post
    follow_redirect!
    return unless assert
  
    assert_match @content, response.body
    assert_select 'a[href=?]', post_path(latest_post), text: 'delete'
  end

  def assert_post_post
    assert_select 'div.pagination'
    assert_select 'form[action=?]', posts_path do |form|
      assert_select form, 'input[type=file]'
    end
    assert_difference('Post.count', 1) { post_post }
    assert_redirected_to root_path
  end

  def post_post
    post posts_path,
         params: { post: { content: @content,
                           picture: fixture_file_upload(*@picture) } }
  end

  def unused_post_id
    used = Post.pluck(:id)
    1.upto(Float::INFINITY).detect { |n| !used.include?(n) }
  end

  def latest_post
    @user.posts.order(created_at: :desc).limit(1)[0]
  end
end
