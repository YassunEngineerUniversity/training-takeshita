require 'rails_helper'

RSpec.describe Relationship, type: :relationship do
  before do
    @relationship = Relationship.new(follower_id: FactoryBot.create(:michael).id,
                                     followee_id: FactoryBot.create(:archer).id)
  end
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(@relationship).to be_valid
    end

    it 'is invalid without a follower_id' do
      @relationship.follower_id = nil
      expect(@relationship).not_to be_valid
    end

    it 'is invalid without a followee_id' do
      @relationship.followee_id = nil
      expect(@relationship).not_to be_valid
    end
  end
end
