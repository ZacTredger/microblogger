require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @user = users.first
    @post = @user.posts.build(content: 'lorem ipsum')
  end

  test 'post is valid' do
    assert @post.valid?
  end

  test 'user_id must be present' do
    @post.user_id = nil
    refute @post.valid?
  end

  test 'content must be present' do
    @post.content = ' '
    refute @post.valid?
  end

  test 'content must be at most 140 characters' do
    @post.content = 'a' * 140
    assert @post.valid?
    @post.content += 'a'
    refute @post.valid?
  end

  test 'orders post with most-recent first' do
    assert_equal posts(:most_recent), users(:FirstUser).posts.first
  end
end
