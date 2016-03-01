class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: [:ranking]
  before_action :logged_in_adminuser, only: [:summary]
  
  def home
    if logged_in?
      @feedbadgeposts = Badgepost.limit(10).where(recept_user_id: current_user.id).where("created_at > ?", 30.days.ago).order(created_at: :desc)
      
      # 30日間に獲得したバッジのグラフ
      @feedgraph_recept30days = get_graph(current_user.id, "", "30DAYS_RECEPT")
    end
  end
  
  # 部門別ランキング
  def ranking
    userjoin = User.arel_table
    badgepostjoin = Badgepost.arel_table
    join_condition = userjoin.join(badgepostjoin, Arel::Nodes::OuterJoin)
                .on(userjoin[:id].eq(badgepostjoin[:sent_user_id])).join_sources
    
    # ランキング表示、3月だけタイムゾーンおかしいので絞りこまずに対応
    # @badgeposts = User.joins(join_condition).group(:bumon_id)
    #           .select(userjoin[:bumon_id], userjoin[:bumon_id].count.as('cnt'))
    #                 .where(badgepostjoin[:created_at].gteq Time.now.beginning_of_month)
    #                 .order('cnt DESC').order(:bumon_id)
    @badgeposts = User.joins(join_condition).group(:bumon_id)
              .select(userjoin[:bumon_id], userjoin[:bumon_id].count.as('cnt'))
                    .where(badgepostjoin[:created_at].gteq Date.today.last_month.beginning_of_month)
                    .order('cnt DESC').order(:bumon_id)
    # 辞書用に部門情報を取得
    bumons = Bumon.where(activeflg: true)
    @bumonname_hash = get_name_hash(bumons)
  end
  
  def summary
    if params[:summary_form] == nil
      # 検索未入力時（初回表示時）
      @form = SummaryForm.new
    else
      # 検索欄入力時
      summary_start_date = Time.zone.local(params[:summary_form]["summary_start_date(1i)"].to_i,
                            params[:summary_form]["summary_start_date(2i)"].to_i,
                            params[:summary_form]["summary_start_date(3i)"].to_i, 0, 0)
      summary_end_date = Time.zone.local(params[:summary_form]["summary_end_date(1i)"].to_i,
                            params[:summary_form]["summary_end_date(2i)"].to_i,
                            params[:summary_form]["summary_end_date(3i)"].to_i, 23, 59)
      @form = SummaryForm.new
      @form.summary_start_date = summary_start_date
      @form.summary_end_date = summary_end_date
      
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
      if Rails.env == 'production'
        @sentbadgeposts = Badgepost.select(:sent_user_id, :badge_id, "to_char(created_at, 'yyyymm') AS create_month", "COUNT(*) AS count")
                            .where('created_at >= ?', @form.summary_start_date)
                            .where('created_at <= ?', @form.summary_end_date)
                            .group(:sent_user_id, :badge_id, "to_char(created_at, 'yyyymm')").order('count DESC')
        @receptbadgeposts = Badgepost.select(:recept_user_id, :badge_id, "to_char(created_at, 'yyyymm') AS create_month", "COUNT(*) AS count")
                            .where('created_at >= ?', @form.summary_start_date)
                            .where('created_at <= ?', @form.summary_end_date)
                            .group(:recept_user_id, :badge_id, "to_char(created_at, 'yyyymm')").order('count DESC')
      elsif Rails.env == 'development' or Rails.env == 'test'
        @sentbadgeposts = Badgepost.select(:sent_user_id, :badge_id, "strftime('%Y%m', created_at) AS create_month", "COUNT(*) AS count")
                            .where('created_at >= ?', @form.summary_start_date)
                            .where('created_at <= ?', @form.summary_end_date)
                            .group(:sent_user_id, :badge_id, "strftime('%Y%m', created_at)").order('count DESC')
        @receptbadgeposts = Badgepost.select(:recept_user_id, :badge_id, "strftime('%Y%m', created_at) AS create_month", "COUNT(*) AS count")
                            .where('created_at >= ?', @form.summary_start_date)
                            .where('created_at <= ?', @form.summary_end_date)
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
