class User < ActiveRecord::Base
  attr_accessor :remember_token, :reset_token
  before_save { self.email = email.downcase }

  validates :bumon, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  VALID_KANANAME_REGEX = /\p{Hiragana}/
  validates :kananame, presence: true, length: { maximum: 50 },
                    format: { with: VALID_KANANAME_REGEX }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password,
    :length => { :minimum => 8, :if => :validate_password? },
    :confirmation => { :if => :validate_password? }

  
  # 画像アップロード
  mount_uploader :image, ImageUploader
  
  belongs_to :bumon, class_name: "Bumon"
  has_many :sent_badgeposts, :class_name => "Badgepost", :foreign_key => "sent_user_id"
  has_many :recept_badgeposts, :class_name => "Badgepost", :foreign_key => "recept_user_id"
  

  # フィードには、自分のささやきと、自分がフォローしているユーザーのつぶやきを表示（取得）
  def feed_badgeposts
    Badgepost.where(recept_user_id: [self.id])
  end
  
  # 与えられた文字列のハッシュ値を返す 
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーログインを破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    # パスワードの有効期限は2時間とする
    reset_sent_at < 2.hours.ago
  end
  
  private
  
    def validate_password?
      password.present? || password_confirmation.present?
    end
end
