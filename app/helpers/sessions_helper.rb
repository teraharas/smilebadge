module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
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

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end