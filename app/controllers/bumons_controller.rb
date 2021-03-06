class BumonsController < ApplicationController
  before_action :logged_in_adminuser
  
  def index
   @bumons = Bumon.all.order(:outputnumber)
  end

  def new
    @bumon = Bumon.new
  end
  
  def edit
    @bumon = Bumon.find(params[:id])
  end
  
  def create
    @bumon = Bumon.new(bumon_params)
    if @bumon.save
      flash[:success] = "新しい部門を登録しました！"
      redirect_to adminpage_path
    else
      render controller: 'bumons', action: 'new'
    end
  end
  
  def update
    @bumon = Bumon.find(params[:id])
    
    if @bumon.update(bumon_params)
      # 保存に成功した場合はトップページへリダイレクト
      flash[:success] = "部門を編集しました。"
      redirect_to adminpage_path
    else
      # 保存に失敗した場合は編集画面へ戻す
      render controller: 'bumons', action: 'edit'
    end
  end


  private
  def bumon_params
    params.require(:bumon).permit(:outputnumber, :name, :activeflg)
  end
end
