class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  
  def index
    if params[:user_find_form] == nil
      @form = UserFindForm.new
      # 自分以外のユーザーを取得する。
      # ソート：カナ（昇順）
      if Rails.env == 'production'
        @users = User.where('id <> ?', current_user.id).where(activeflg: true).order('kananame COLLATE "C"')
      elsif Rails.env == 'development' or Rails.env == 'test'
        @users = User.where('id <> ?', current_user.id).where(activeflg: true).order(:kananame)
      end
    else
      @form = UserFindForm.new(find_params)
      @searchword = @form.searchword.gsub("　", " ")
      t = User.arel_table
      
      # 自分以外のユーザーを取得する。
      # ソート：カナ（昇順）
      if Rails.env == 'production'
        @users = User.where('id <> ?', current_user.id)
          .where(t[:activeflg].eq(true))
          .where(t[:name].matches('%' + @searchword + '%')
            .or(t[:kananame].matches('%' + @searchword + '%'))
            .or(t[:email].matches('%' + @searchword + '%')))
            .order('kananame COLLATE "C"')
      elsif Rails.env == 'development' or Rails.env == 'test'
        @users = User.where('id <> ?', current_user.id)
          .where(t[:activeflg].eq(true))
          .where(t[:name].matches('%' + @searchword + '%')
            .or(t[:kananame].matches('%' + @searchword + '%'))
            .or(t[:email].matches('%' + @searchword + '%')))
            .order(:kananame)
      end
    end
  end
  
  
  def full_index
    if params[:user_find_form] == nil
      @form = UserFindForm.new
      # 自分以外のユーザーを取得する。
      # ソート：カナ（昇順）
      if Rails.env == 'production'
        @users = User.all.order('kananame COLLATE "C"')
      elsif Rails.env == 'development' or Rails.env == 'test'
        @users = User.all.order(:kananame)
      end
    else
      @form = UserFindForm.new(find_params)
      @searchword = @form.searchword.gsub("　", " ")
      t = User.arel_table
      
      # 自分以外のユーザーを取得する。
      # ソート：カナ（昇順）
      if Rails.env == 'production'
        @users = User.where(t[:name].matches('%' + @searchword + '%')
                .or(t[:kananame].matches('%' + @searchword + '%'))
                .or(t[:email].matches('%' + @searchword + '%')))
                .order('kananame COLLATE "C"')
      elsif Rails.env == 'development' or Rails.env == 'test'
        @users = User.where(t[:name].matches('%' + @searchword + '%')
                .or(t[:kananame].matches('%' + @searchword + '%'))
                .or(t[:email].matches('%' + @searchword + '%')))
                .order(:kananame)
      end
    end
  end
  
  
  def find
    binding.pry
    @form = UserFindForm.new
  end
  
  
  def show
    @user = User.find(params[:id])
    
    # 30日間に獲得したバッジのグラフ
    @graph_recept30days = get_graph(@user.id, "30DAYS_RECEPT")
   
    # 今までに獲得したバッジのグラフ
    @graph_recept = get_graph(@user.id, "ALL_RECEPT")
    
    # 今までに贈ったバッジのグラフ
    @graph_sent = get_graph(@user.id, "ALL_SENT")
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
      # 保存に成功した場合はプロフィールページへリダイレクト
      flash[:success] = "プロフィールを編集しました。"
      redirect_to @user
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
  

  private
  def user_params
    params.require(:user)
      .permit(:activeflg, :bumon_id, :name, :kananame, :nickname, :adminflg,
            :email, :password, :password_confirmation,
            :catchphrase, :myword, :hobby, :message,
            :image, :remove_image, :image_cache)
  end
  
  def find_params
    params.require(:user_find_form).permit(:searchword)
  end
  
  def get_graph(user_id, type)
    # グラフインスタンス取得
    
    badgejoin = Badge.arel_table
    badgepostjoin = Badgepost.arel_table
    
    join_condition = badgejoin.join(badgepostjoin, Arel::Nodes::OuterJoin)
              .on(badgejoin[:id].eq(badgepostjoin[:badge_id])).join_sources
    
    if type == "30DAYS_RECEPT"
      @badgeposts = Badge.joins(join_condition).group(:id, :name, :image, :outputnumber)
            .select(badgejoin[:id], badgejoin[:name], badgejoin[:image], badgejoin[:outputnumber], badgejoin[:id].count.as('cnt'))
            .where(badgepostjoin[:recept_user_id].eq(user_id))
            .where(badgepostjoin[:created_at].gt 30.days.ago)
            .order('cnt DESC')
    elsif type == "ALL_RECEPT"
      @badgeposts = Badge.joins(join_condition).group(:id, :name, :image, :outputnumber)
            .select(badgejoin[:id], badgejoin[:name], badgejoin[:image], badgejoin[:outputnumber], badgejoin[:id].count.as('cnt'))
            .where(badgepostjoin[:recept_user_id].eq(user_id))
            .order('cnt DESC')
    else
      @badgeposts = Badge.joins(join_condition).group(:id, :name, :image, :outputnumber)
            .select(badgejoin[:id], badgejoin[:name], badgejoin[:image], badgejoin[:outputnumber], badgejoin[:id].count.as('cnt'))
            .where(badgepostjoin[:sent_user_id].eq(user_id))
            .order('cnt DESC')
    end

    data = Array.new
    
    @badgeposts.each do |badgepost|
      data.push([badgepost.name, badgepost.cnt])
    end
    
    @graph = LazyHighCharts::HighChart.new('graph') do |f|
      # グラフタイトル
      if type == "30DAYS_RECEPT"
        f.title(text: '30日間に獲得したバッジバランス')
      elsif type == "ALL_RECEPT"
        f.title(text: '今までに獲得したバッジバランス')
      else
        f.title(text: '今までに贈ったバッジバランス')
      end
      f.series(name: 'バッジ数', data: data, type: 'pie')
    end
  end
end
