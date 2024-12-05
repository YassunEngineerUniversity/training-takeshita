module Api
  class PostsController < ApplicationController
    before_action :logged_in_user, only: %i[index show create destroy]
    before_action :correct_user,   only: :destroy

    def show
      # パラメータからidを取得
      @post = Post.find(params[:id])

      # JSONレスポンスを返す
      render json: {
        content: @post.content,
        created_at: @post.created_at
      }, status: :ok
    rescue ActiveRecord::RecordNotFound
      # レコードが見つからない場合
      render json: { error: 'Post not found' }, status: :not_found
    end

    def create
      @post = current_user.posts.build(post_params)
      @post.image.attach(params[:post][:image])
      if @post.save
        render json: @post, status: :created
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end

    private

    def post_params
      params.require(:post).permit(:content, :image)
    end
  end
end
