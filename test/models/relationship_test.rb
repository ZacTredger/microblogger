require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  setup do
    @relationship = Relationship.new(follower: users(:FirstUser),
                                     followed: users(:SecondUser))
  end

  test 'it is valid' do
    assert @relationship.valid?
  end

  test 'it requires a follower ID' do
    @relationship.follower_id = nil
    refute @relationship.valid?
  end

  test 'it requires a followed ID' do
    @relationship.followed_id = nil
    refute @relationship.valid?
  end
end
