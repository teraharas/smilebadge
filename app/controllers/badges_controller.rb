class BadgesController < ApplicationController
  def index
   @badges = Badge.all.order(:outputnumber)
    # binding.pry
  end

  
  def new
    @badge = Badge.new
  end
  
  
#   def show
#     @badge = Badge.find(params[:id])
#   end
  
  
  def edit
    @badge = Badge.find(params[:id])
  end
  
  
  def create
    @badge = Badge.new(badge_params)
    if @badge.save
      flash[:success] = "新しいバッジを登録しました！"
      redirect_to controller: 'badges', action: 'index'
    else
      render controller: 'badges', action: 'new'
    end
  end
  
  
  def update
    @badge = Badge.find(params[:id])
    
    if @badge.update(badge_params)
      # 保存に成功した場合はトップページへリダイレクト
      flash[:success] = "バッジを編集しました。"
      redirect_to controller: 'badges', action: 'index'
    else
      # 保存に失敗した場合は編集画面へ戻す
      render controller: 'badges', action: 'edit'
    end
  end


  private
  def badge_params
    params.require(:badge).permit(:outputnumber, :name, :explanation, :image, :remove_image, :image_cache)
  end
end
