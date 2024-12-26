class ApplicationController < ActionController::API
  include SessionsHelper
  include ActionController::Cookies # cookieを使用するために追加

  private

  # ユーザーのログインを確認する
  def logged_in_user
    return if logged_in?

    render json: { error: 'Unauthorized' }, status: :unauthorized
    # render json: { error: 'Unauthorized' }, status: :unprocessable_entity
  end
end
