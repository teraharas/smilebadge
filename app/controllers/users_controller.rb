class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  
  def index
    # 自分以外のユーザーを取得する。
    # ソート：カナ（昇順）
    if Rails.env == 'production'
      @users = User.where('id <> ?', current_user.id).order('kananame COLLATE "C"')
    elsif Rails.env == 'development'
      @users = User.where('id <> ?', current_user.id).order(:kananame)
    elsif Rails.env == 'test'
      @users = User.where('id <> ?', current_user.id).order(:kananame)
    end
  end
  
  def show
    @user = User.find(params[:id])
    
    
    # 30日間に獲得したバッジ
    badgejoin_recept30days = Badge.arel_table
    badgepostjoin_recept30days = Badgepost.arel_table
    
    join_condition_recept30days = badgejoin_recept30days.join(badgepostjoin_recept30days, Arel::Nodes::OuterJoin)
              .on(badgejoin_recept30days[:id].eq(badgepostjoin_recept30days[:badge_id])).join_sources

    @badgeposts_recept30days = Badge.joins(join_condition_recept30days).group(:id, :name, :image, :outputnumber)
            .select(badgejoin_recept30days[:id], badgejoin_recept30days[:name], badgejoin_recept30days[:image], badgejoin_recept30days[:outputnumber], badgejoin_recept30days[:id].count.as('cnt'))
            .where(badgepostjoin_recept30days[:recept_user_id].eq(current_user.id))
            .where(badgepostjoin_recept30days[:created_at].gt 30.days.ago)
            .order('cnt DESC')
            # .limit(10)
    data = Array.new
    
    @badgeposts_recept30days.each do |badgepost|
      data.push([badgepost.name, badgepost.cnt])
    end
    
    @graph_recept30days = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '30日間に獲得したバッジバランス')
      f.series(name: 'バッジ数', data: data, type: 'pie')
    end
    
    
   
    # 今までに獲得したバッジ
    badgejoin_recept = Badge.arel_table
    badgepostjoin_recept = Badgepost.arel_table
    
    join_condition_recept = badgejoin_recept.join(badgepostjoin_recept, Arel::Nodes::OuterJoin)
              .on(badgejoin_recept[:id].eq(badgepostjoin_recept[:badge_id])).join_sources

    @badgeposts_recept = Badge.joins(join_condition_recept).group(:id, :name, :image, :outputnumber)
            .select(badgejoin_recept[:id], badgejoin_recept[:name], badgejoin_recept[:image], badgejoin_recept[:outputnumber], badgejoin_recept[:id].count.as('cnt'))
            .where(badgepostjoin_recept[:recept_user_id].eq(current_user.id))
            .order('cnt DESC')
            # .limit(10)
    data = Array.new
    
    @badgeposts_recept.each do |badgepost|
      data.push([badgepost.name, badgepost.cnt])
    end
    
    @graph_recept = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '今までに獲得したバッジバランス')
      f.series(name: 'バッジ数', data: data, type: 'pie')
    end
    
    
    
    # 今までに贈ったバッジ
    badgejoin_sent = Badge.arel_table
    badgepostjoin_sent = Badgepost.arel_table
    
    join_condition_sent = badgejoin_sent.join(badgepostjoin_sent, Arel::Nodes::OuterJoin)
              .on(badgejoin_sent[:id].eq(badgepostjoin_sent[:badge_id])).join_sources

    @badgeposts_sent = Badge.joins(join_condition_sent).group(:id, :name, :image, :outputnumber)
            .select(badgejoin_sent[:id], badgejoin_sent[:name], badgejoin_sent[:image], badgejoin_sent[:outputnumber], badgejoin_sent[:id].count.as('cnt'))
            .where(badgepostjoin_sent[:sent_user_id].eq(current_user.id))
            .order('cnt DESC')
            # .limit(10)
    data = Array.new
    
    @badgeposts_sent.each do |badgepost|
      data.push([badgepost.name, badgepost.cnt])
    end
    
    @graph_sent = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '今までに贈ったバッジバランス')
      f.series(name: 'バッジ数', data: data, type: 'pie')
    end
  end
  
  
  def new
    @user = User.new
  end
  

  def edit
    @user = User.find(params[:id])
  end
  

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "登録しました！ログインしてください！"
      redirect_to login_path
    else
      render 'new'
    end
  end
  
  
  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      # 保存に成功した場合はトップページへリダイレクト
      flash[:success] = "プロフィールを編集しました。"
      redirect_to @user
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
  

  private
  def user_params
    params.require(:user).permit(:activeflg, :bumon_id, :name, :kananame, :nickname, :adminflg,
                                  :email, :password, :password_confirmation,
                                  :myword, :hobby, :message,
                                  :image, :remove_image, :image_cache)
  end
end
