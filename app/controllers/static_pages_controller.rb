class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: [:ranking]
  before_action :logged_in_adminuser, only: [:summary]
  
  def home
    if logged_in?
      redirect_to :action => "login_top"
    end
  end
  
  def login_top
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
    
    @badgeposts = User.joins(join_condition).group(:bumon_id)
              .select(userjoin[:bumon_id], userjoin[:bumon_id].count.as('cnt'))
                    .where(badgepostjoin[:created_at].gteq Time.now.beginning_of_month)
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
      set_search_form_params
      
      set_master_data
      
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
  
  def summary_recept_badge_user
    if params[:summary_form] == nil
      # 検索未入力時（初回表示時）
      @form = SummaryForm.new
    else
      # 検索欄入力時
      set_search_form_params
      
      # マスター情報関連取得
      set_master_data
      
      @receptbadgeposts = Badgepost.select(:recept_user_id, :badge_id, "COUNT(*) AS count")
                            .where('created_at >= ?', @form.summary_start_date)
                            .where('created_at <= ?', @form.summary_end_date)
                            .group(:recept_user_id, :badge_id)
                            .order('badge_id, count DESC, recept_user_id')
    end
  end
  
  def summary_value_send
    if params[:summary_form] == nil
      # 検索未入力時（初回表示時）
      @form = SummaryForm.new
    else
      # 検索欄入力時
      set_search_form_params
      
      # マスター情報関連取得
      set_master_data
      
      value_badge_ids = Badge.select(:id).where(optionflg: false)

      @sentbadgeposts = Badgepost.select(:sent_user_id, "COUNT(*) AS count")
                            .where('created_at >= ?', @form.summary_start_date)
                            .where('created_at <= ?', @form.summary_end_date)
                            .where(badge_id: value_badge_ids)
                            .group(:sent_user_id).order('count DESC, sent_user_id')
    end
  end
  
  def summary_value_bumon_send
    if params[:summary_form] == nil
      # 検索未入力時（初回表示時）
      @form = SummaryForm.new
    else
      # 検索欄入力時
      set_search_form_params
      
      # マスター情報関連取得
      set_master_data
      
      value_badge_ids = Badge.select(:id).where(optionflg: false)
      
      userjoin = User.arel_table
      badgepostjoin = Badgepost.arel_table
      join_condition = userjoin.join(badgepostjoin, Arel::Nodes::OuterJoin)
                  .on(userjoin[:id].eq(badgepostjoin[:sent_user_id])).join_sources
      
      @sentbadgeposts = User.joins(join_condition).group(:bumon_id)
                .select(userjoin[:bumon_id], userjoin[:bumon_id].count.as('count'))
                      .where(badgepostjoin[:created_at].gteq @form.summary_start_date)
                      .where(badgepostjoin[:created_at].lteq @form.summary_end_date)
                      .where(badgepostjoin[:badge_id].in(value_badge_ids.map{|badge| badge.id }))
                      .order('count DESC').order(:bumon_id)
    end
  end
  
  private
    def find_params
      params.require(:summary_form).permit(:summary_start_date, :summary_end_date)
    end
    
    def set_search_form_params
      summary_start_date = Time.zone.local(params[:summary_form]["summary_start_date(1i)"].to_i,
                            params[:summary_form]["summary_start_date(2i)"].to_i,
                            params[:summary_form]["summary_start_date(3i)"].to_i, 0, 0)
      summary_end_date = Time.zone.local(params[:summary_form]["summary_end_date(1i)"].to_i,
                            params[:summary_form]["summary_end_date(2i)"].to_i,
                            params[:summary_form]["summary_end_date(3i)"].to_i, 23, 59)
      @form = SummaryForm.new
      @form.summary_start_date = summary_start_date
      @form.summary_end_date = summary_end_date
    end
    
    def set_master_data
      # まず、ユーザーをすべて取得（ユーザーと部門名を取得）
      @users = User.all
      @userinfo_hash = get_user_hash(@users)
      
      # 辞書用にバッジ情報を取得
      badges = Badge.where(activeflg: true)
      badges.each do |badge|
        if badge.optionflg
          badge.name = "【2】" + badge.outputnumber.to_s + "." + badge.name
        else
          badge.name = "【1】" + badge.outputnumber.to_s + "." + badge.name
        end
      end
      @badgename_hash = get_name_hash(badges)
      
      # 辞書用に部門情報を取得
      bumons = Bumon.where(activeflg: true)
      @bumonname_hash = get_name_hash(bumons)
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
