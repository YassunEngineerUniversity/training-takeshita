require 'rails_helper'

RSpec.describe 'Api::Posts', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe '認証のないリクエスト' do
    context 'ログインしていない状態' do
      let(:existing_post) { FactoryBot.create(:post) }

      it 'POST /api/posts/:id/likeが401エラーを返すこと' do
        post "/api/posts/#{existing_post.id}/like"
        expect(response).to have_http_status(:unauthorized)
      end

      # it 'DELETE /api/posts/:id/likeが401エラーを返すこと' do
      #   delete "/api/posts/#{existing_post.id}/like"
      #   expect(response).to have_http_status(:unauthorized)
      # end
    end
  end

  describe 'POST /api/posts/:id/like' do
    # ログイン処理
    before do
      post '/api/login', params: { session: { email: user.email, password: 'password' } }
    end
    let(:existing_post) { FactoryBot.create(:post) }

    it '投稿にいいねできること' do
      expect do
        post "/api/posts/#{existing_post.id}/like"
      end.to change(Like, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    context '同じ投稿に2回いいねした場合' do
      before do
        create(:like, user: user, post: existing_post)
      end

      it '2回目のいいねは失敗すること' do
        expect do
          post "/api/posts/#{existing_post.id}/like"
        end.not_to change(Like, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # describe 'DELETE /api/posts/:id/like' do
  #   let(:existing_post) { FactoryBot.create(:post) }
  #   let!(:like) { create(:like, user: user, post: existing_post) }

  #   it 'いいねを解除できること' do
  #     expect do
  #       delete "/api/posts/#{existing_post.id}/like"
  #     end.to change(Like, :count).by(-1)

  #     expect(response).to have_http_status(:ok)
  #   end
  # end
end
