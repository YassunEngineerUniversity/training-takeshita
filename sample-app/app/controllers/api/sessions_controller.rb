module Api
  class SessionsController < ApplicationController
    def create
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        if user.activated?
          reset_session
          # params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          log_in user
          render json: {
            message: 'ログイン成功',
            user: {
              id: user.id,
              email: user.email
            }
          }, status: :ok
        else
          render json: {
            error: 'アカウントが有効化されていません'
          }, status: :unauthorized
        end
      else
        render json: {
          error: 'メールアドレスまたはパスワードが間違っています'
        }, status: :unauthorized
      end
    end

    def destroy
      log_out if logged_in?
      # redirect_to root_url, status: :see_other
    end
  end
end
