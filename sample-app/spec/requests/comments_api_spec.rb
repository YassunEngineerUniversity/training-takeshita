require 'rails_helper'

RSpec.describe 'Api::Posts', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:content_params) { { comment: { content: 'test' } } }

  describe '認証のないリクエスト' do
    context 'ログインしていない状態' do
      let(:existing_post) { FactoryBot.create(:post) }
      it 'POST /api/posts/:id/commentsが401エラーを返すこと' do
        post "/api/posts/#{existing_post.id}/comments", params: content_params
        expect(response).to have_http_status(:unauthorized)
      end

      # it 'DELETE /api/posts/:id/commentsが401エラーを返すこと' do
      #   delete "/api/posts/#{existing_post.id}/comments"
      #   expect(response).to have_http_status(:unauthorized)
      # end
    end
  end

  describe 'POST /api/posts/:id/comments' do
    # ログイン処理
    before do
      post '/api/login', params: { session: { email: user.email, password: 'password' } }
    end
    let(:existing_post) { FactoryBot.create(:post) }

    it '投稿にコメントできること' do
      expect do
        post "/api/posts/#{existing_post.id}/comments", params: content_params
      end.to change(Comment, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  # describe 'DELETE /api/posts/:id/comments' do
  #   let(:existing_post) { FactoryBot.create(:post) }
  #   let(:existing_comment) { FactoryBot.create(:comment) }
  #   # ログイン処理
  #   before do
  #     post '/api/login', params: { session: { email: user.email, password: 'password' } }
  #   end

  #   it 'コメントを削除できること' do
  #     create(:comment, user: user, post: existing_post)
  #     expect do
  #       delete "/api/posts/#{existing_post.id}/comments", params: existing_comment.id
  #     end.to change(Comment, :count).by(-1)

  #     expect(response).to have_http_status(:see_other)
  #   end

  #   it 'コメントをしていない投稿への「コメント削除」はできないこと' do
  #     expect do
  #       delete "/api/posts/#{existing_post.id}/comments"
  #     end.not_to change(Comment, :count)

  #     expect(response).to have_http_status(:unprocessable_entity)
  #   end
  # end
end
