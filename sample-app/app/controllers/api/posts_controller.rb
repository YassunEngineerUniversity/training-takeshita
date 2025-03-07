module Api
  class PostsController < ApplicationController
    before_action :logged_in_user, only: %i[index show create destroy all mine]
    before_action :correct_user,   only: :destroy

    def index
      @feed_items = Post.joins('LEFT JOIN follow_users ON follow_users.followee_id = posts.user_id')
                        .joins(:user) # Add explicit join with users table
                        .includes(:user, image_attachment: :blob)
                        .where('follow_users.follower_id = :user_id OR posts.user_id = :user_id', user_id: current_user.id)
                        .select('posts.*, users.name as user_name') # Select posts fields and user name
                        .distinct
                        .page(params[:page])

      # 各ポストに対してcurrent_userがいいねをしているかを確認
      @feed_items = @feed_items.map do |post|
        liked = post.likes.exists?(user_id: current_user.id) # current_userがいいねをしているか確認
        post.attributes.merge(liked: liked) # likedを追加
      end
      render json: @feed_items, status: :ok
    end

    def show
      # パラメータからidを取得
      @post = Post.find(params[:id])

      # current_userが@postにいいねをしているか確認
      @liked = current_user.likes.exists?(post_id: @post.id)

      @comments = @post.comments
      @comments = @comments.map do |comment|
        comment.attributes.merge(user_name: comment.user.name)
      end

      # JSONレスポンスを返す
      render json: {
        post: {
          id: @post.id,
          content: @post.content,
          user_id: @post.user_id,
          user_name: @post.user.name,
          created_at: @post.created_at,
          updated_at: @post.updated_at,
          liked: @liked # いいねの状態を追加
        },
        comments: @comments
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

      # 各ポストに対してcurrent_userがいいねをしているかを確認
      @all_posts = @all_posts.map do |post|
        liked = current_user.likes.exists?(post_id: post.id)
        post.attributes.merge(liked: liked) # likedを追加
      end
      render json: @all_posts, status: :ok
    end

    def mine
      @my_posts = current_user.posts.page(params[:page])
                              .joins(:user) # Add explicit join with users table
                              .select('posts.*, users.name as user_name')
      # 各ポストに対してcurrent_userがいいねをしているかを確認
      @my_posts = @my_posts.map do |post|
        liked = current_user.likes.exists?(post_id: post.id)
        post.attributes.merge(liked: liked) # likedを追加
      end
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
