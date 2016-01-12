class Mongon < ActiveRecord::Base
  validates :kubun, presence: true,
              numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to:10 },
              uniqueness: { case_sensitive: false }
  validates :content, length: { maximum: 500 }
end
