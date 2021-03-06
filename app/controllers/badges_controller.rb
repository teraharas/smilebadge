class BadgesController < ApplicationController
  before_action :logged_in_adminuser
  
  def index
   @badges = Badge.all.order(:outputnumber)
  end

  def new
    @badge = Badge.new
  end

  def edit
    @badge = Badge.find(params[:id])
  end

  def create
    @badge = Badge.new(badge_params)
    if @badge.save
      flash[:success] = "新しいバッジを登録しました！"
      redirect_to adminpage_path
    else
      render controller: 'badges', action: 'new'
    end
  end

  def update
    @badge = Badge.find(params[:id])
    
    if @badge.update(badge_params)
      # 保存に成功した場合はトップページへリダイレクト
      flash[:success] = "バッジを編集しました。"
      redirect_to adminpage_path
    else
      # 保存に失敗した場合は編集画面へ戻す
      render controller: 'badges', action: 'edit'
    end
  end


  private
  def badge_params
    params.require(:badge)
    .permit(:outputnumber, :name, :explanation,
          :level1_title, :level2_title, :activeflg, :optionflg,
          :image, :remove_image, :image_cache)
  end
end
