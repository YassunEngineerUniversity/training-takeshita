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

  describe 'micropost associations' do
    it 'destroys associated microposts when user is destroyed' do
      @user.save
      @user.microposts.create!(content: 'Lorem ipsum')
      expect { @user.destroy }.to change(Micropost, :count).by(-1)
      @user.destroy
    end
  end

  describe 'following' do
    michael = FactoryBot.create(:michael)
    archer = FactoryBot.create(:archer)
    lana = FactoryBot.create(:lana)

    context 'when following users' do
      it 'follows and unfollows a user' do
        expect(michael.following?(archer)).to be_falsey

        michael.follow(archer)
        expect(michael.following?(archer)).to be_truthy
        expect(archer.followers).to include(michael)

        michael.unfollow(archer)
        expect(michael.following?(archer)).to be_falsey
      end
      it 'cannot follow self' do
        michael.follow(michael)
        expect(michael.following?(michael)).to be_falsey
      end
    end

    describe 'feed' do
      before do
        michael.follow(lana)
      end

      it 'includes own posts' do
        michael.microposts.each do |post_self|
          expect(michael.feed).to include(post_self)
        end
      end

      it 'includes followed user posts' do
        lana.microposts.each do |post_following|
          expect(michael.feed).to include(post_following)
        end
      end

      it 'excludes unfollowed user posts' do
        archer.microposts.each do |post_unfollowed|
          expect(michael.feed).not_to include(post_unfollowed)
        end
      end
    end
  end
end
