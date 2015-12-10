class User < ActiveRecord::Base
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
    :length => { :minimum => 4, :if => :validate_password? },
    :confirmation => { :if => :validate_password? }

  
  # 画像アップロード
  mount_uploader :image, ImageUploader
  
  belongs_to :bumon, class_name: "Bumon"
  has_many :sent_badgeposts, :class_name => "Badgepost", :foreign_key => "sent_user_id"
  has_many :recept_badgeposts, :class_name => "Badgepost", :foreign_key => "recept_user_id"
  
  # フィードには、自分のささやきと、自分がフォローしているユーザーのつぶやきを表示（取得）
  def feed_items
    Badgepost.where(recept_user_id: [self.id])
  end
  
  private

  def validate_password?
    password.present? || password_confirmation.present?
  end
end
