module Api
  class FollowUsersController < ApplicationController
    before_action :logged_in_user

    def create
      @user = User.find(params[:id])
      current_user.follow(@user)
      render json: current_user.followees, status: :created
    end

    def destroy
      @user = User.find(params[:id])
      # @user = FollowUser.find(params[:id]).followee
      current_user.unfollow(@user)
      render json: @user.followees, status: :see_other
    end
  end
end
