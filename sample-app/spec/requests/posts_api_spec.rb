require 'rails_helper'

RSpec.describe 'Api::Posts', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }

  describe '認証のないリクエスト' do
    context 'ログインしていない状態' do
      let(:post_params) { { content: 'テスト投稿' } }

      it 'POST /api/postsが401エラーを返すこと' do
        post '/api/posts', params: post_params
        expect(response).to have_http_status(:unauthorized)
      end

      it 'GET /api/postsが401エラーを返すこと' do
        get '/api/posts'
        expect(response).to have_http_status(:unauthorized)
      end
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

  describe 'GET /api/posts' do
    before do
      post '/api/login', params: { session: { email: user.email, password: 'password' } }
      # post '/api/posts', params: { post: FactoryBot.build(:post) }
      post '/api/posts', params: { post: { content: 'test1' } }
      post '/api/posts', params: { post: { content: 'test2' } }
      # create_list(:post, 3, user: user)
      # create_list(:post, 2, user: another_user)
    end

    it '全ての投稿を取得できること' do
      get '/api/posts'

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body.size).to eq 2
    end
  end

  describe 'GET /api/posts/:id' do
    let(:test_post) { create(:post, user: user) }

    context 'ログインしていない場合' do
      it 'GET /api/posts/:idが401エラーを返すこと' do
        get "/api/posts/#{test_post.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'ログインしている場合' do
      # ログイン処理
      before do
        post '/api/login', params: { session: { email: user.email, password: 'password' } }
      end
      it 'GET /api/posts/:idが403エラーを返すこと' do
        get '/api/posts/1000'
        expect(response).to have_http_status(:not_found)
      end

      it '特定の投稿を取得できること' do
        get "/api/posts/#{test_post.id}"

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['post']['content']).to eq test_post.content
      end
    end
  end
end
