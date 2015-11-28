class UsersController < ApplicationController
  
  def index
    # 自分以外のユーザーを取得する。
    @users = User.where('id <> ?', current_user.id).order(id: :desc)

  end
  
  def show
    @user = User.find(params[:id])
   
    badgejoin = Badge.arel_table
    badgepostjoin = Badgepost.arel_table
    
    join_condition = badgejoin.join(badgepostjoin, Arel::Nodes::OuterJoin).
              on(badgejoin[:id].eq(badgepostjoin[:badge_id])).join_sources

    @badgeposts = Badge.joins(join_condition).group(:id, :name, :image, :outputnumber).
            select(badgejoin[:id], badgejoin[:name], badgejoin[:image], badgejoin[:outputnumber], badgejoin[:id].count.as('cnt')).
            where(badgepostjoin[:recept_user_id].eq(current_user.id)).
            order('cnt DESC').limit(10)

    @badges = Badge.all.order(:outputnumber).limit(10)
   
    genre = Array.new
    @badges.each do |badge|
    genre.push(badge.name)
  end
   
    data = Array.new
    
    @badgeposts.each do |badgepost|
      data.push([badgepost.name, badgepost.cnt])
    end
    
    @graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'もらったバッジバランス')
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
                                  :image1, :remove_image1, :image_cache1, :image2, :remove_image2, :image_cache2)
  end
end
