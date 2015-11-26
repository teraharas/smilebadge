class Badgepost < ActiveRecord::Base
  belongs_to :sent_user, class_name: "User"
  belongs_to :recept_user, class_name: "User"
  belongs_to :badge, class_name: "Badge"
  
  validates :sent_user_id, presence: true
  validates :recept_user_id, presence: true
  validates :badge_id, presence: true
  validates :content, length: { maximum: 140 }
end
