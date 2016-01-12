class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :find, :show,
                                        :edit, :edit_password, :update]
  before_action :logged_in_adminuser, only: [:full_index, :new, :create ]
  before_action :editable_user,   only: [:edit, :update]

  
  def index
    # カレントユーザーを表示しない
    @users = get_index_users(false, params[:initial_letter], params[:bumon_id])
  end
  
  
  def full_index
    # カレントユーザー含め全ユーザーを表示する
    @users = get_index_users(true, params[:initial_letter], params[:bumon_id])
  end
  
  
  def find
    @form = UserFindForm.new
  end
  
  
  def show
    @user = User.find(params[:id])
    
    # 30日間に獲得したバッジのグラフ
    @graph_recept30days = get_graph(@user.id, "", "30DAYS_RECEPT")
   
    # 今までに獲得したバッジのグラフ
    @graph_recept = get_graph(@user.id, "", "ALL_RECEPT")
    
    # 今までに贈ったバッジのグラフ
    @graph_sent = get_graph(@user.id, "", "ALL_SENT")
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
      flash[:success] = "ユーザー「" + @user.name + "」を登録しました！"
      redirect_to adminpage_path
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
              :myjob, :myword, :hobby, :message,
              :image, :remove_image, :image_cache)
    end
    
    def find_params
      params.require(:user_find_form).permit(:searchword)
    end
    
    def get_index_users(display_current_user, initial_letter, bumon_id)
      @bumons = Bumon.where(activeflg: true).order(:outputnumber)
      
      if params[:user_find_form] == nil
        # 検索未入力時（初回表示時）
        @form = UserFindForm.new
        # 自分以外のユーザーを取得する。
        # ソート：カナ（昇順）
        t = User.arel_table

        if display_current_user
          if initial_letter.present?
            @users = User.paginate(page: params[:page])
                          .where(t[:kananame].matches(initial_letter + '%'))
          elsif bumon_id.present?
            @users = User.paginate(page: params[:page])
                          .where(bumon_id: bumon_id)
            # 30日間に獲得したバッジのグラフ
            @graph_recept30days = get_graph("", bumon_id, "30DAYS_RECEPT")
          else
            @users = User.paginate(page: params[:page])
          end
        else
          if initial_letter.present?
            @users = User.paginate(page: params[:page])
                    .where('id <> ?', current_user.id)
                    .where(activeflg: true)
                    .where(t[:kananame].matches(initial_letter + '%'))
          elsif bumon_id.present?
            @users = User.paginate(page: params[:page])
                    .where('id <> ?', current_user.id)
                    .where(activeflg: true)
                    .where(bumon_id: bumon_id)
            # 30日間に獲得したバッジのグラフ
            @graph_recept30days = get_graph("", bumon_id, "30DAYS_RECEPT")
          else
            @users = User.paginate(page: params[:page])
                    .where('id <> ?', current_user.id)
                    .where(activeflg: true)
          end
        end
        
        if Rails.env == 'production'
          @users.order('kananame COLLATE "C"')
        elsif Rails.env == 'development' or Rails.env == 'test'
          @users.order(:kananame)
        end
      else
        # 検索欄入力時
        @form = UserFindForm.new(find_params)
        @searchword = @form.searchword.gsub("　", " ")
        t = User.arel_table
        
        # 自分以外のユーザーを取得する。
        # ソート：カナ（昇順）
        @users = User.paginate(page: params[:page])
                      .where(t[:name].matches('%' + @searchword + '%')
                        .or(t[:kananame].matches('%' + @searchword + '%'))
                        .or(t[:email].matches('%' + @searchword + '%')))
        
        if display_current_user
          @users = User.paginate(page: params[:page])
                    .where(t[:name].matches('%' + @searchword + '%')
                      .or(t[:kananame].matches('%' + @searchword + '%'))
                      .or(t[:email].matches('%' + @searchword + '%')))
        else
        @users = User.paginate(page: params[:page])
                    .where('id <> ?', current_user.id)
                    .where(t[:activeflg].eq(true))
                    .where(t[:name].matches('%' + @searchword + '%')
                      .or(t[:kananame].matches('%' + @searchword + '%'))
                      .or(t[:email].matches('%' + @searchword + '%')))
        end
  
        if Rails.env == 'production'
          @users.order('kananame COLLATE "C"')
        elsif Rails.env == 'development' or Rails.env == 'test'
          @users.order(:kananame)
        end
      end
    end
end
