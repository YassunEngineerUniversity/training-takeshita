module Api
  class LikesController < ApplicationController
    before_action :logged_in_user, only: %i[create]
    # before_action :logged_in_user, only: %i[create destroy]
    # before_action :correct_user,   only: :destroy

    def create
      if current_user.likes.find_by(id: params[:id]).nil?
        @post = Post.find(params[:id])
        @like = @post.likes.build(user: current_user)
        if @like.save
          head :created
        else
          render json: @like.errors, status: :unprocessable_entity
        end

      else
        head :unprocessable_entity
      end
    end

    # def destroy
    #   if @like.destroy
    #     head :see_other
    #   else
    #     render json: @like.errors, status: :unprocessable_entity
    #   end
    # end

    # private

    # def correct_user
    #   @like = current_user.likes.find_by(id: params[:id])
    #   render status: :see_other if @like.nil?
    # end
  end
end
