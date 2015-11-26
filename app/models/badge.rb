class Badge < ActiveRecord::Base
    # 画像アップロード
    mount_uploader :image, ImageUploader
    
    validates :outputnumber, presence: true,
                        numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to:10 },
                        uniqueness: { case_sensitive: false }
                        
    has_many :badgeposts, :class_name => "Badgepost", :foreign_key => "badge_id"
end
