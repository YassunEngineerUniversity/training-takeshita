module Api
  class PostsController < ApplicationController
    before_action :logged_in_user, only: %i[index show create destroy]
    before_action :correct_user,   only: :destroy

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
