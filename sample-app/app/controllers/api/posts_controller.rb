module Api
  class PostsController < ApplicationController
    before_action :logged_in_user, only: %i[index show create destroy all mine]
    before_action :correct_user,   only: :destroy

    def index
      # @feed_items = current_user.feed.paginate(page: params[:page]) # will_paginate
      @feed_items = current_user.feed.page(params[:page]) # kaminari
      render json: @feed_items, status: :ok
    end

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

    def destroy
      @post.destroy
      if request.referrer.nil?
        redirect_to root_url, status: :see_other
      else
        redirect_to request.referrer, status: :see_other
      end
    end

    def all
      @all_posts = Post.all.page(params[:page])
                       .joins(:user) # Add explicit join with users table
                       .select('posts.*, users.name as user_name')
      render json: @all_posts, status: :ok
    end

    def mine
      @my_posts = current_user.posts.page(params[:page])
                              .joins(:user) # Add explicit join with users table
                              .select('posts.*, users.name as user_name')
      render json: @my_posts, status: :ok
    end

    private

    def post_params
      params.require(:post).permit(:content, :image)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @post.nil?
    end
  end
end
