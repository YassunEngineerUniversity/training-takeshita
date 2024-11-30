class ApplicationController < ActionController::API
  include SessionsHelper
  include ActionController::Cookies # cookieを使用するために追加

  private

  # ユーザーのログインを確認する
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url, status: :see_other
  end
end
