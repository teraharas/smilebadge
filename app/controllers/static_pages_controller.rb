class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @feedbadgeposts = Badgepost.limit(10).where(recept_user_id: current_user.id).where("created_at > ?", 30.days.ago).order(created_at: :desc)
    end
  end
  
  def summary
    # まず、ユーザーをすべて取得（ユーザーと部門名を取得）
    @users = User.all
    @userinfo_hash = get_user_hash(@users)
    
    # 辞書用にバッジ情報を取得
    badges = Badge.where(activeflg: true)
    @badgename_hash = get_name_hash(badges)
    
    # 辞書用に部門情報を取得
    bumons = Bumon.where(activeflg: true)
    @bumonname_hash = get_name_hash(bumons)

    # 画面で指定された範囲に作成されたBadgepostを集計
    @sentbadgeposts = Badgepost.select(:sent_user_id, :badge_id, "strftime('%Y%m', created_at) AS create_month", "COUNT(*) AS count")
                          .where('created_at >= ?', 30.days.ago)
                          .group(:sent_user_id, :badge_id, "strftime('%Y%m', created_at)")

    @receptbadgeposts = Badgepost.select(:recept_user_id, :badge_id, "strftime('%Y%m', created_at) AS create_month", "COUNT(*) AS count")
                          .where('created_at >= ?', 30.days.ago)
                          .group(:recept_user_id, :badge_id, "strftime('%Y%m', created_at)")
    
    # binding.pry
  end
  
  private
    def get_user_hash(users)
      results = users.map{|user| [user.id, user]}
      Hash[results]
    end

    def get_name_hash(objects)
      results = objects.map{|object| [object.id, object.name]}
      Hash[results]
    end
end
