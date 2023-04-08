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
end
