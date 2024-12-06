require 'rails_helper'

RSpec.describe 'Api::FollowUsers', type: :request do
  let(:current_user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }

  describe '認証のないリクエスト' do
    context 'ログインしていない状態' do
      it 'GET /api/users/#{another_user.id}が401エラーを返すこと' do
        get "/api/users/#{another_user.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/users/#{another_user.id}' do
    # ログイン処理
    before do
      post '/api/login', params: { session: { email: current_user.email, password: 'password' } }
    end
    context 'ユーザーの情報取得' do
      it '成功' do
        get "/api/users/#{another_user.id}"
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['user_info']['name']).to eq another_user.name
        expect(JSON.parse(response.body)['posts_info']).to eq another_user.posts
      end
    end
  end
end
