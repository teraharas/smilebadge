class BadgepostsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def recepting
    @badgeposts = Badgepost.where(recept_user_id: current_user.id).order(created_at: :desc)
  end
  
  def sending
    @badgeposts = Badgepost.where(sent_user_id: current_user.id).order(created_at: :desc)
  end
  
  def new
    @badgepost = Badgepost.new
    @recept_user = User.find(params[:recept_user_id])
    
    # バリューバッジ
    @valuebadges = Badge.where(optionflg: false).where(activeflg: true).order(:outputnumber)
    # アソビバッジ
    @optionbadges = Badge.where(optionflg: true).where(activeflg: true).order(:outputnumber)
    # アソビバッジの今月の使用数
    @badgecounthash = get_badge_count_hash(@optionbadges)
  end

  def create
    @badgepost = current_user.sent_badgeposts.build(badgepost_params)
    
    if @badgepost.save
      
      # バッジ受け取りメール送信
      # NoticeMailer.mail_recept_badge(@badgepost).deliver_later

      flash[:success] = @badgepost.recept_user.name + "さんに「" + @badgepost.badge.name + "」バッジを贈りました！"
      redirect_to root_url
    else
      if @badgepost.badge_id.nil?
        flash[:danger] = "送信失敗！バッジを選んでから送信してください！"
      elsif @badgepost.content.empty?
        flash[:danger] = "送信失敗！メッセージを入力してから送信してください！"
      else
        flash[:danger] = "送信失敗！バッジを送信できませんでした。"
      end
      redirect_to new_badgepost_path(recept_user_id: badgepost_params[:recept_user_id])
    end
  end
  
  private
    def badgepost_params
      params.require(:badgepost).permit(:sent_user_id, :recept_user_id, :badge_id, :content)
    end
    
    def get_badge_count_hash(optionbadges)
      # IN句に挿入する配列を準備
      in_string = Array.new(0, nil)
      optionbadges.each do |optionbadge|
        in_string.push(optionbadge.id)
      end
      
      from = Time.now.at_beginning_of_month
      to   = from + 1.month
      optionbadgecounts = Badgepost.select("badge_id, count(*) as badgecount")
                          .where(sent_user_id: current_user.id)
                          .where(created_at: from...to)
                          .where('badge_id IN(?)', in_string)
                          .group(:badge_id)
                          
      results = optionbadgecounts.map{|optionbadgecount| [optionbadgecount.badge_id, optionbadgecount.badgecount]}
      Hash[results]
    end
end
