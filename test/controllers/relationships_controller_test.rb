require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test 'create requires logged-in user' do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  test 'destroy requires logged-in user' do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end
end
