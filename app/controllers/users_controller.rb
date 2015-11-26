class UsersController < ApplicationController
  
  def index
    # 自分以外のユーザーを取得する。
    @users = User.where('id <> ?', current_user.id).order(id: :desc)
    
    
    # user = User.arel_table
    # badgepost = Badgepost.arel_table
    
    # join_condition = user.join(badgepost, Arel::Nodes::OuterJoin).
    #           on(user[:id].eq(badgepost[:recept_user_id])).join_sources

    # @users = User.joins(join_condition).group(:id, :name, :image).
    #         select(user[:id], user[:name], user[:image], badgepost[:id].count.as('cnt')).
    #         where(user[:id].not_eq(current_user.id)).
    #         order('cnt DESC').order(user[:id])
            
  # binding.pry
            
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
   
   
  # binding.pry
   
    genre = Array.new
    @badges.each do |badge|
    genre.push(badge.name)
  end
   
  # binding.pry
   
    # # genre = ['アイデア','チャレンジ','ナイスアクション','熱血', 'アンテナ', 'コミュニケーション', 'カイゼン', 'スピード', '向上心', 'タフ']
    # # aData = [7,3,2,8,10,2,3,7,10,1]

    # aData = [0,0,0,0,0,0,0,0,0,0]
    # # aData = Array.new
    
    # # binding.pry
    
    # @maxbagecount = 1
    
    # @badgeposts.each do |badgepost|
    #   # binding.pry
    #   aData[badgepost.outputnumber - 1] = aData[badgepost.outputnumber - 1] + badgepost.cnt
      
    #   # バッジ獲得数の最大値をセットする
    #   if badgepost.cnt > @maxbagecount
    #     @maxbagecount = badgepost.cnt
    #   end
    # end
    # # bData = [5,5,4,7,5,5,4,6,5,5] #二件目のデータ
    
    # # binding.pry

    # @graph = LazyHighCharts::HighChart.new('graph') do |f|
    #   f.chart(polar: true, type:'line') 
    #   f.pane(size:'100%')                  
    #   # f.title(text: 'パワーグラフ')         
    #   f.xAxis(categories: genre,tickmarkPlacement:'on')    
    #   f.yAxis(gridLineInterpolation: 'polygon',lineWidth:0, min:0, max:@maxbagecount)
    #   # f.series(name: current_user.name + 'さん',data: aData, pointPlacement:'on', type: 'area') #areaは塗りつぶしのため
    #   f.series(data: aData, pointPlacement:'on', type: 'area') #areaは塗りつぶしのため
    #   # f.series(name:'情報システム課の平均',data: bData, pointPlacement:'on')
    #   f.legend(align: 'center',
	   #     verticalAlign: 'top',
	   #     y: 0,
	   #     layout: 'vertical')
    # end
    
    # data = [['DataA', 45.0],['DataB', 55.0]]
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
    params.require(:user).permit(:name, :kananame, :email, :password,
                                 :password_confirmation,
                                 :bumon_id, :activeflg, :adminflg, :myword, :hobby, :message,
                                 :image, :remove_image, :image_cache)
  end
end
