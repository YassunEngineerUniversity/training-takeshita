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
require 'rails_helper'

RSpec.describe FollowUser, type: :follow_user do
  before do
    @follow_user = FollowUser.new(follower_id: FactoryBot.create(:user).id,
                                  followee_id: FactoryBot.create(:user).id)
  end
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(@follow_user).to be_valid
    end

    it 'is invalid without a follower_id' do
      @follow_user.follower_id = nil
      expect(@follow_user).not_to be_valid
    end

    it 'is invalid without a followee_id' do
      @follow_user.followee_id = nil
      expect(@follow_user).not_to be_valid
    end
  end
end
