# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  post_id  (post_id => posts.id)
#  user_id  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Like, type: :comment do
  before do
    @user = FactoryBot.create(:user)
    @post = @user.posts.create(content: 'Lorem ipsum')
    @comment = @post.comments.build(user: @user, content: 'Lorem ipsum')
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(@comment).to be_valid
    end

    it 'is invalid without a user id' do
      @comment.user_id = nil
      expect(@comment).not_to be_valid
    end

    it 'is invalid without a user id' do
      @comment.post_id = nil
      expect(@comment).not_to be_valid
    end

    it 'is invalid with blank content' do
      @comment.content = '   '
      expect(@comment).not_to be_valid
    end

    it 'is invalid with content longer than 140 characters' do
      @comment.content = 'a' * 141
      expect(@comment).not_to be_valid
    end

    # it 'orders most recent comments first' do
    #   expect(FactoryBot.create(:comment, user: @user)).to eq(Like.first)
    # end
  end
end
