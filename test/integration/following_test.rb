require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:FirstUser)
    @other = users(:FourthUser)
    log_in_as(@user)
  end

  test 'follows a user with standard request' do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  test 'follows a user with AJAX request' do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }, xhr: true
    end
  end

  test 'unfollows a user with standard request' do
    relationship = @user.active_relationships.first
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test 'unfollows a user with AJAX request' do
    relationship = @user.active_relationships.first
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end

  test 'following page' do
    get following_user_path(@user)
    refute @user.following.empty?
    # Find link to followERS in followING page, in case self-referential
    # followERS link is removed
    assert_select 'a[href=?]', followers_user_path(@user),
                  text: /#{@user.followers.count}/
    @user.following.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test 'followers page' do
    get followers_user_path(@user)
    refute @user.followers.empty?
    # Find link to followING in followERS page, in case self-referential
    # followERS link is removed
    assert_select 'a[href=?]', followers_user_path(@user),
                  text: /#{@user.followers.count}/
    @user.followers.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end
end
