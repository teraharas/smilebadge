class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @feedbadgeposts = Badgepost.limit(10).where(recept_user_id: current_user.id).where("created_at > ?", 30.days.ago).order(created_at: :desc)
    end
  end
  
  def summary
    if params[:summary_form] == nil
      # 検索未入力時（初回表示時）
      @form = SummaryForm.new
    else
      binding.pry
      # 検索欄入力時
      @form = SummaryForm.new(params[:summary_form])
      
      # まず、ユーザーをすべて取得（ユーザーと部門名を取得）
      @users = User.all
      @userinfo_hash = get_user_hash(@users)
      
      # 辞書用にバッジ情報を取得
      badges = Badge.where(activeflg: true)
      @badgename_hash = get_name_hash(badges)
      
      # 辞書用に部門情報を取得
      bumons = Bumon.where(activeflg: true)
      @bumonname_hash = get_name_hash(bumons)
      
      binding.pry
  
      # 画面で指定された範囲に作成されたBadgepostを集計
      if Rails.env == 'production'
        @sentbadgeposts = Badgepost.select(:sent_user_id, :badge_id, "to_char(created_at, 'yyyymm') AS create_month", "COUNT(*) AS count")
                            .where('created_at >= ?', @form.summary_start_date)
                            .group(:sent_user_id, :badge_id, "to_char(created_at, 'yyyymm')").order('count DESC')
        @receptbadgeposts = Badgepost.select(:recept_user_id, :badge_id, "to_char(created_at, 'yyyymm') AS create_month", "COUNT(*) AS count")
                            .where('created_at >= ?', @form.summary_start_date)
                            .group(:recept_user_id, :badge_id, "to_char(created_at, 'yyyymm')").order('count DESC')
      elsif Rails.env == 'development' or Rails.env == 'test'
        @sentbadgeposts = Badgepost.select(:sent_user_id, :badge_id, "strftime('%Y%m', created_at) AS create_month", "COUNT(*) AS count")
                            .where('created_at >= ?', @form.summary_start_date)
                            .group(:sent_user_id, :badge_id, "strftime('%Y%m', created_at)").order('count DESC')
        @receptbadgeposts = Badgepost.select(:recept_user_id, :badge_id, "strftime('%Y%m', created_at) AS create_month", "COUNT(*) AS count")
                            .where('created_at >= ?', @form.summary_start_date)
                            .group(:recept_user_id, :badge_id, "strftime('%Y%m', created_at)").order('count DESC')
      end
    end
  end
  
  private
    def find_params
      params.require(:summary_form).permit(:summary_start_date, :summary_end_date)
    end
  
    def get_user_hash(users)
      results = users.map{|user| [user.id, user]}
      Hash[results]
    end

    def get_name_hash(objects)
      results = objects.map{|object| [object.id, object.name]}
      Hash[results]
    end
end
