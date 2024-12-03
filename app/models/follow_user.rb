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
class FollowUser < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'
  validates :follower_id, presence: true
  validates :followee_id, presence: true
end
