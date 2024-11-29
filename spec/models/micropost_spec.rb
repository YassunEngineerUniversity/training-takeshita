require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before do
    @user = FactoryBot.create(:michael)
    @micropost = @user.microposts.build(content: 'Lorem ipsum')
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(@micropost).to be_valid
    end

    it 'is invalid without a user id' do
      @micropost.user_id = nil
      expect(@micropost).not_to be_valid
    end

    it 'is invalid with blank content' do
      @micropost.content = '   '
      expect(@micropost).not_to be_valid
    end

    it 'is invalid with content longer than 140 characters' do
      @micropost.content = 'a' * 141
      expect(@micropost).not_to be_valid
    end

    it 'orders most recent posts first' do
      expect(FactoryBot.create(:micropost, user: @user)).to eq(Micropost.first)
    end
  end
end
