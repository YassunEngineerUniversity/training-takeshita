module Api
  class CommentsController < ApplicationController
    before_action :logged_in_user, only: %i[create destroy]

    def create
      @post = Post.find(params[:id])
      @comment = @post.comments.build(user: current_user, content: comment_params)
      if @comment.save
        head :created
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
      # render json: params
    end

    def destroy
      @comment = current_user.comments.find_by(id: params[:id])
      if @comment && @comment.destroy
        head :see_other
      else
        render json: { error: '無効なリクエスト' }, status: :unprocessable_entity
      end
    end

    private

    def comment_params
      params.require(:post).permit(:content)
    end
  end
end
