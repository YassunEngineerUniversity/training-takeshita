require 'rails_helper'

RSpec.describe FollowUser, type: :follow_user do
  before do
    @follow_user = FollowUser.new(follower_id: FactoryBot.create(:michael).id,
                                     followee_id: FactoryBot.create(:archer).id)
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
