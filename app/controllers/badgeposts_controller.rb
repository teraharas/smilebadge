class BadgepostsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def recepting
    @badgeposts = Badgepost.where(:recept_user_id => current_user.id).order(created_at: :desc)
  end
  
  def sending
    @badgeposts = Badgepost.where(:sent_user_id => current_user.id).order(created_at: :desc)
  end
  
  def new
    @badges = Badge.all.order(:outputnumber)
    @badgepost = Badgepost.new
    
    @recept_user = User.find(params[:recept_user_id])
    # binding.pry
  end

  def create
    @badgepost = current_user.sent_badgeposts.build(badgepost_params)
    if @badgepost.save
      # バッジ受け取りメール送信
      NoticeMailer.mail_recept_badge(@badgepost).deliver
      flash[:success] = @badgepost.recept_user.name + "さんに「" + @badgepost.badge.name + "」バッジを贈りました！"
      redirect_to root_url
    else
      flash[:info] = "送信失敗！バッジを選んでから送信してください！"
      redirect_to root_url
    end
  end
  
  private
  def badgepost_params
    params.require(:badgepost).permit(:sent_user_id, :recept_user_id, :badge_id, :content)
  end
end
