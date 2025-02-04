# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  activation_digest :string
#  admin             :boolean          default(FALSE)
#  email             :string
#  name              :string
#  password_digest   :string
#  remember_digest   :string
#  reset_digest      :string
#  reset_sent_at     :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'foobarbaz', password_confirmation: 'foobarbaz')
  end
  describe 'validations' do
    context 'when attributes are valid' do
      it 'is valid with valid attributes' do
        expect(@user).to be_valid
      end
    end

    context 'when attributes are invalid' do
      it 'is invalid without a name' do
        @user.name = ' ' * 5
        expect(@user).not_to be_valid
      end

      it 'is invalid without an email' do
        @user.email = ' ' * 5
        expect(@user).not_to be_valid
      end

      it 'is invalid with a name that is too long' do
        @user.name = 'a' * 51
        expect(@user).not_to be_valid
      end

      it 'is invalid with an email that is too long' do
        @user.email = 'a' * 244 + '@example.com'
        expect(@user).not_to be_valid
      end

      it 'check valid email addresses' do
        valid_addresses = %w[user@exmple.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end

      it 'rejects invalid email addresses' do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                               foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).not_to be_valid, "#{invalid_address.inspect} should be invalid"
        end
      end

      it 'requires unique email addresses' do
        duplicate_user = @user.dup
        @user.save
        expect(duplicate_user).not_to be_valid
      end

      it 'requires a non-blank password' do
        @user.password = @user.password_confirmation = ' ' * 8
        expect(@user).not_to be_valid
      end

      it 'requires a minimum password length' do
        @user.password = @user.password_confirmation = 'a' * 5
        expect(@user).not_to be_valid
      end
    end
  end

  describe 'authenticated?' do
    it 'returns false for a user with nil digest' do
      expect(@user.authenticated?(:remember, '')).to be_falsey
    end
  end

  describe 'post associations' do
    it 'destroys associated posts when user is destroyed' do
      @user.save
      @user.posts.create!(content: 'Lorem ipsum')
      expect { @user.destroy }.to change(Post, :count).by(-1)
      @user.destroy
    end
  end

  describe 'following' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    FactoryBot.create(:user)

    context 'when following users' do
      it 'follows and unfollows a user' do
        expect(user1.following?(user2)).to be_falsey

        user1.follow(user2)
        expect(user1.following?(user2)).to be_truthy
        expect(user2.followers).to include(user1)

        user1.unfollow(user2)
        expect(user1.following?(user2)).to be_falsey
      end
      it 'cannot follow self' do
        user1.follow(user1)
        expect(user1.following?(user1)).to be_falsey
      end
    end

    # describe 'feed' do
    #   before do
    #     user1.follow(user3)
    #   end

    #   it 'includes own posts' do
    #     user1.posts.each do |post_self|
    #       expect(user1.feed).to include(post_self)
    #     end
    #   end

    #   it 'includes followed user posts' do
    #     user3.posts.each do |post_following|
    #       expect(user1.feed).to include(post_following)
    #     end
    #   end

    #   it 'excludes unfollowed user posts' do
    #     user2.posts.each do |post_unfollowed|
    #       expect(user1.feed).not_to include(post_unfollowed)
    #     end
    #   end
    # end
  end
end
