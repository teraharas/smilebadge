class SessionsController < ApplicationController
  
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    # ログインでき、かつ有効ユーザーならOK
    if @user && @user.authenticate(params[:session][:password]) && @user.activeflg
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      flash[:info] = "#{@user.name}でログインしました！バッジを贈って「褒める」をカタチにしよう！"
      redirect_to root_url
    else
      flash.now[:danger] = 'メールアドレスかパスワードが間違っています。'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
