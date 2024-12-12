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
    # let!(:posts) { FactoryBot.create(:post, user: another_user) }
    let!(:posts) { FactoryBot.create_list(:post, 50, user: another_user) }
    # ログイン処理
    before do
      post '/api/login', params: { session: { email: current_user.email, password: 'password' } }
    end
    context 'ユーザーの情報取得' do
      it '成功' do
        get "/api/users/#{another_user.id}"
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['user_info']['name']).to eq another_user.name
        expect(JSON.parse(response.body)['posts_info'][0]['content']).to eq another_user.posts[0].content
      end
    end
    context 'kaminari pagination' do
      it 'コンテンツ数が作製した投稿と同数' do
        get "/api/users/#{another_user.id}?page=1"
        expect(JSON.parse(response.body)['posts_info'].count).to eq 30
        get "/api/users/#{another_user.id}?page=2"
        expect(JSON.parse(response.body)['posts_info'].count).to eq 20
      end
    end
    context '投稿の内容を検証する' do
      it '30件の投稿の内容が正しいこと' do
        get "/api/users/#{another_user.id}?page=1"
        (0..29).each do |i|
          expect(JSON.parse(response.body)['posts_info'][i]['content']).to eq another_user.posts[i].content
        end
      end
    end
  end
end
