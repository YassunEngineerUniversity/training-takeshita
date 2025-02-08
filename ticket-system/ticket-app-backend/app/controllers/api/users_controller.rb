module Api
  class UsersController < ApplicationController
    before_action :logged_in_user, only: %i[index show edit update destroy]
    before_action :correct_user,   only: %i[edit update]

    def show
      @user = User.find(params[:id])
      # @posts = @user.posts.paginate(page: params[:page]) # will_paginate
      @posts = @user.posts.page(params[:page]) # kaminari

      # 各ポストに対してcurrent_userがいいねをしているかを確認
      @posts = @posts.map do |post|
        liked = post.likes.exists?(user_id: current_user.id) # current_userがいいねをしているか確認
        post.attributes.merge(user_name: post.user.name, liked: liked) # likedを追加
      end

      render json: { user_info: { user_id: @user.id, name: @user.name, registration_date: @user.created_at, followed: current_user.following?(@user) }, posts_info: @posts },
             status: :ok
    end

    def create
      # @user = User.new(user_params) # 実装は終わっていないことに注意!
      # if @user.save
      #   @user.send_activation_email
      #   flash[:info] = 'Please check your email to activate your account.'
      #   redirect_to root_url
      # else
      #   render 'new', status: :unprocessable_entity
      # end
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        flash[:success] = 'Profile updated'
        redirect_to @user
      else
        render 'edit', status: :unprocessable_entity
      end
    end

    def destroy
      User.find(params[:id]).destroy
      render json: { message: 'User deleted' }, status: :ok
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  end
end
