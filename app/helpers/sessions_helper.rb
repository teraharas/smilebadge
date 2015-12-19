module SessionsHelper
  
  # ログインしていなければ促す
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
  
  # 編集権限があるユーザーか
  def editable_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless ( current_user?(@user) || logged_in_adminuser?)
  end
  
  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 自分のユーザーか
  def current_user?(user)
    user == current_user
  end
  
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ログイン中か
  def logged_in?
    !current_user.nil?
  end
  
  # 管理者ユーザーでログインをさせる
  def logged_in_adminuser
      current_user
      redirect_to(root_url) unless ( (!@current_user.nil? && @current_user.adminflg) || !User.exists?(adminflg: true) )
  end
  
  # 管理者権限でログインしているか（管理者ユーザー不在の時はログインしなくてもOK）
  def logged_in_adminuser?
    current_user
    # 管理者ユーザーのときか、管理者ユーザーが存在していないとき
    if @current_user.adminflg || !User.exists?(adminflg: true)
      return true
    else
      return false
    end
  end
  
  # ユーザーを永続的セッションに記憶する
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end