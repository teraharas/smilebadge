class Badge < ActiveRecord::Base
    validates :name, presence: true, length: { maximum: 50 }
    validates :explanation, presence: true, length: { maximum: 255 }
    validates :outputnumber, presence: true,
                        numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to:10 },
                        uniqueness: { case_sensitive: false }
                        
    # 画像アップロード
    mount_uploader :image, ImageUploader
    
    has_many :badgeposts, :class_name => "Badgepost", :foreign_key => "badge_id"
end
