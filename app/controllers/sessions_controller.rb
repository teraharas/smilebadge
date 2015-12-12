class SessionsController < ApplicationController
  
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    # ログインでき、かつ有効ユーザーならOK
    if @user && @user.authenticate(params[:session][:password]) && @user.activeflg
      session[:user_id] = @user.id
      flash[:info] = "#{@user.name}でログインしました！バッジを贈って「褒める」をカタチにしよう！"
      redirect_to root_url
    else
      flash.now[:danger] = 'メールアドレスかパスワードが間違っています。'
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
