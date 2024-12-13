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
      it 'フォローに成功すること' do
        expect do
          post "/api/users/#{another_user.id}/follow"
        end.to change(current_user.followees, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'DELETE /api/users/#{another_user.id}/follow' do
    # ログイン、フォロー処理
    before do
      post '/api/login', params: { session: { email: current_user.email, password: 'password' } }
      post "/api/users/#{another_user.id}/follow"
    end
    context 'フォロー解除成功' do
      it 'フォローの解除に成功すること' do
        expect do
          delete "/api/users/#{another_user.id}/follow"
        end.to change(current_user.followees, :count).by(-1)
        expect(response).to have_http_status(:see_other)
      end
    end
  end
end
