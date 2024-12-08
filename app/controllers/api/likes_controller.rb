module Api
  class LikesController < ApplicationController
    before_action :logged_in_user, only: %i[create destroy]

    def create
      @post = Post.find(params[:id])
      @like = @post.likes.build(user: current_user)
      if @like.save
        head :created
      else
        render json: @like.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @like = current_user.likes.find_by(id: params[:id])
      if @like && @like.destroy
        head :see_other
      else
        render json: { error: '無効なリクエスト' }, status: :unprocessable_entity
      end
    end
  end
end
