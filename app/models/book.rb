class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(method, search_word)#selfはクラス自身のこと、ここではBook
    if method == "perfect"
      Book.where(title: search_word)
    elsif method == "forward"
      Book.where("title LIKE ?", "#{search_word}%")
    elsif method == "backward"
      Book.where("title LIKE ?", "%#{search_word}")
    else
      Book.where("title LIKE ?", "%#{search_word}%")
    end
  end
  
#  def self.fav_counting
  #   Favorite.group(:book_id).where(created_at: 1.week.ago.beginning_of_day..Time.zone.now.end_of_day).count.pluck(:book_id)
  # end
end
