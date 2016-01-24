class MongonsController < ApplicationController
  before_action :logged_in_adminuser
  
  def index
   @mongons = Mongon.all.order(:kubun)
  end

  def new
    @mongon = Mongon.new
  end
  
  def edit
    @mongon = Mongon.find(params[:id])
  end
  
  def create
    @mongon = Mongon.new(mongon_params)
    if @mongon.save
      flash[:success] = "新しい文言を登録しました！"
      redirect_to adminpage_path
    else
      render controller: 'mongons', action: 'new'
    end
  end
  
  def update
    @mongon = Mongon.find(params[:id])
    
    if @mongon.update(mongon_params)
      # 保存に成功した場合はトップページへリダイレクト
      flash[:success] = "文言を編集しました。"
      redirect_to adminpage_path
    else
      # 保存に失敗した場合は編集画面へ戻す
      render controller: 'mongons', action: 'edit'
    end
  end

  def destroy
    @mongon = Mongon.find(params[:id])
    @mongon.destroy
    flash[:success] = "文言を削除しました"
    redirect_to request.referrer || root_url
  end

  private
  def mongon_params
    params.require(:mongon).permit(:kubun, :content)
  end
end
