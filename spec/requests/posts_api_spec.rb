require 'rails_helper'

RSpec.describe 'Api::Posts', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }

  describe '認証のないリクエスト' do
    context 'ログインしていない状態' do
      let(:post_params) { { content: 'テスト投稿' } }
      let(:existing_post) { { content: 'テスト' } }

      it 'POST /api/postsが401エラーを返すこと' do
        post '/api/posts', params: post_params
        expect(response).to have_http_status(:unauthorized)
      end
  end

  describe 'POST /api/posts' do
    # ログイン処理
    before do
      post '/api/login', params: { session: { email: user.email, password: 'password' } }
    end
    context '有効なパラメータの場合' do
      let(:valid_params) { { post: { content: 'テスト投稿' } } }

      it '投稿の作成に成功すること' do
        expect do
          post '/api/posts', params: valid_params
        end.to change(Post, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['content']).to eq 'テスト投稿'
      end
    end

    context '不正なパラメータの場合' do
      let(:invalid_params) { { post: { content: '' } } }

      it '投稿の作成に失敗すること' do
        expect do
          post '/api/posts', params: invalid_params
        end.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
