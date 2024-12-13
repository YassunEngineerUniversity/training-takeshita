require 'rails_helper'

RSpec.describe 'Login API', type: :request do
  # FactoryBotでユーザーを作成するためのファクトリ
  let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

  describe 'POST /api/login' do
    context '有効な認証情報の場合' do
      before do
        # テスト用のPOSTリクエストパラメータ
        @login_params = {
          session: {
            email: user.email,
            password: 'password123'
          }
        }
      end

      it 'ログインに成功すること' do
        post '/api/login', params: @login_params

        # レスポンスのステータスコードを確認
        expect(response).to have_http_status(:ok)

        # レスポンスボディを確認
        response_body = JSON.parse(response.body)
        expect(response_body).to include('message' => 'ログイン成功')
        expect(response_body['user']).to include(
          'id' => user.id,
          'email' => user.email
        )
      end

      it 'セッションにユーザーIDが保存されること' do
        post '/api/login', params: @login_params

        # セッションにユーザーIDが正しく保存されているか確認
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context '無効な認証情報の場合' do
      context 'メールアドレスが存在しない場合' do
        before do
          @invalid_email_params = {
            session: {
              email: 'nonexistent@example.com',
              password: 'password123'
            }
          }
        end

        it '認証に失敗すること' do
          post '/api/login', params: @invalid_email_params

          # 認証失敗のステータスコードを確認
          expect(response).to have_http_status(:unauthorized)

          # エラーメッセージを確認
          response_body = JSON.parse(response.body)
          expect(response_body).to include('error' => 'メールアドレスまたはパスワードが間違っています')
        end
      end

      context 'パスワードが間違っている場合' do
        before do
          @invalid_password_params = {
            session: {
              email: user.email,
              password: 'wrongpassword'
            }
          }
        end

        it '認証に失敗すること' do
          post '/api/login', params: @invalid_password_params

          # 認証失敗のステータスコードを確認
          expect(response).to have_http_status(:unauthorized)

          # エラーメッセージを確認
          response_body = JSON.parse(response.body)
          expect(response_body).to include('error' => 'メールアドレスまたはパスワードが間違っています')
        end
      end
    end
  end
end
