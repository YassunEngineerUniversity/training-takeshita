# == Schema Information
#
# Table name: follow_users
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followee_id :integer
#  follower_id :integer
#
# Indexes
#
#  index_follow_users_on_followee_id                  (followee_id)
#  index_follow_users_on_follower_id                  (follower_id)
#  index_follow_users_on_follower_id_and_followee_id  (follower_id,followee_id) UNIQUE
#
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
