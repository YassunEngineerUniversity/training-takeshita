module Api
  class SessionsController < ApplicationController
    def create
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        if user.activated?
          session[:forwarding_url]
          reset_session
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          log_in user
          render json: {
            message: 'ログイン成功',
            user: {
              id: user.id,
              email: user.email
            }
          }, status: :ok
          # redirect_to forwarding_url || user
        else
          render json: {
            error: 'アカウントが有効化されていません'
          }, status: :unauthorized
          # message  = 'Account not activated. '
          # message += 'Check your email for the activation link.'
          # flash[:warning] = message
          # redirect_to root_url
        end
      else
        render json: {
          error: 'メールアドレスまたはパスワードが間違っています'
        }, status: :unauthorized
        # flash.now[:danger] = 'Invalid email/password combination'
        # render 'new', status: :unprocessable_entity
      end
    end

    def destroy
      log_out if logged_in?
      # redirect_to root_url, status: :see_other
    end
  end
end
