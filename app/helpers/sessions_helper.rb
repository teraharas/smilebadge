module SessionsHelper
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
  
  def current_user?(user)
    user == current_user
  end
  
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !current_user.nil?
  end
  
  def logged_in_adminuser?
    current_user
    # binding.pry
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

  # 現在のユーザーがログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end