class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 4 }
  
  # 画像アップロード
  mount_uploader :image, ImageUploader
  
  belongs_to :bumon, class_name: "Bumon"
  has_many :sent_badgeposts, :class_name => "Badgepost", :foreign_key => "sent_user_id"
  has_many :recept_badgeposts, :class_name => "Badgepost", :foreign_key => "recept_user_id"
  
  # フィードには、自分のささやきと、自分がフォローしているユーザーのつぶやきを表示（取得）
  def feed_items
    Badgepost.where(recept_user_id: [self.id])
  end
end
