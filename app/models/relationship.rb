class Relationship < ApplicationRecord
  
  belongs_to :follower, class_name: "User"
  has_many :followeds, class_name: "User", foreign_key: "followed_id", dependent: :destroy
  has_many :follows, through: :followeds, source: :users
  
  
  belongs_to :followed, class_name: "User"
  has_many :followers, class_name: "User", foreign_key: "follower_id", dependent: :destroy
  has_many :follows, throuth: :followers, source: :users
  
  
  
end
