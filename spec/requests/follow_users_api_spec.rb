require 'rails_helper'

RSpec.describe 'Api::FollowUsers', type: :request do
  let(:current_user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }

  describe '認証のないリクエスト' do
    context 'ログインしていない状態' do
      it 'POST /api/users/#{another_user.id}/followが401エラーを返すこと' do
        post "/api/users/#{another_user.id}/follow"
        expect(response).to have_http_status(:unauthorized)
      end

      it 'DELETE /api/users/#{another_user.id}/followが401エラーを返すこと' do
        delete "/api/users/#{another_user.id}/follow"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/users/#{another_user.id}/follow' do
    # ログイン処理
    before do
      post '/api/login', params: { session: { email: current_user.email, password: 'password' } }
    end
    context 'フォロー成功' do
      it '投稿の作成に成功すること' do
        expect do
          post "/api/users/#{another_user.id}/follow"
        end.to change(current_user.followees, :count).by(1)
        binding.pry
        expect(response).to have_http_status(:created)
      end
    end
  end
end
