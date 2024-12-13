require 'test_helper'

class FollowUsersControllerTest < ActionDispatch::IntegrationTest
  test 'create should require logged-in user' do
    assert_no_difference 'FollowUser.count' do
      post follow_users_path
    end
    assert_redirected_to login_url
  end

  test 'destroy should require logged-in user' do
    assert_no_difference 'FollowUser.count' do
      delete follow_user_path(follow_users(:one))
    end
    assert_redirected_to login_url
  end
end
