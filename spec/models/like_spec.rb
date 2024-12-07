# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_likes_on_post_id                 (post_id)
#  index_likes_on_post_id_and_created_at  (post_id,created_at)
#  index_likes_on_user_id                 (user_id)
#  index_likes_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  post_id  (post_id => posts.id)
#  user_id  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Like, type: :like do
  before do
    @user = FactoryBot.create(:user)
    @post = @user.posts.create(content: 'Lorem ipsum')
    @like = @post.likes.build(user: @user)
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(@like).to be_valid
    end

    it 'is invalid without a user id' do
      @like.user_id = nil
      expect(@like).not_to be_valid
    end

    it 'is invalid without a user id' do
      @like.post_id = nil
      expect(@like).not_to be_valid
    end

    # it 'orders most recent likes first' do
    #   expect(FactoryBot.create(:like, user: @user)).to eq(Like.first)
    # end
  end
end
