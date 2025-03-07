module Api
  class SessionsController < ApplicationController
    before_action :authorized_ticket_agency

    def index
      if current_user
        render json: {
          id: current_user.id,
          name: current_user.name
        }, status: :ok
      else
        render json: { error: 'Not logged in' }, status: :unauthorized
      end
    end

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
      head :no_content
    end
  end
end
