class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :view_counts, dependent: :destroy

  has_many :week_favorites, -> { where(created_at:
  ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}


  scope :created_today, -> { where(created_at: Time.current.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 1.week.ago.at_beginning_of_day..Time.current.at_end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.at_beginning_of_day..1.week.ago.at_end_of_day) }

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

  # def self.fav_sorting
  #   all.sort_by{ |books| [books.favorites.count] }.reverse
  # end

end
