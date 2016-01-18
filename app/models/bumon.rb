class Bumon < ActiveRecord::Base
    validates :name, presence: true, length: { maximum: 50 }
    validates :outputnumber, presence: true,
                        numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to:100 },
                        uniqueness: { case_sensitive: false }

    has_many :users
end
