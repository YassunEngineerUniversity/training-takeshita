# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_posts_on_user_id                 (user_id)
#  index_posts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Poste: :model do
  before do
    @user = FactoryBot.create(:michael)
    @post = @user.posts.build(content: 'Lorem ipsum')
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(@post).to be_valid
    end

    it 'is invalid without a user id' do
      @post.user_id = nil
      expect(@post).not_to be_valid
    end

    it 'is invalid with blank content' do
      @post.content = '   '
      expect(@post).not_to be_valid
    end

    it 'is invalid with content longer than 140 characters' do
      @post.content = 'a' * 141
      expect(@post).not_to be_valid
    end

    it 'orders most recent posts first' do
      expect(FactoryBot.create(:post, user: @user)).to eq(Post.first)
    end
  end
end
