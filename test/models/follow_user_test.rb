require 'test_helper'

class FollowUserTest < ActiveSupport::TestCase
  def setup
    @follow_user = FollowUser.new(follower_id: users(:michael).id,
                                     followee_id: users(:archer).id)
  end

  test 'should be valid' do
    assert @follow_user.valid?
  end

  test 'should require a follower_id' do
    @follow_user.follower_id = nil
    assert_not @follow_user.valid?
  end

  test 'should require a followee_id' do
    @follow_user.followee_id = nil
    assert_not @follow_user.valid?
  end
end
