class Tag < ApplicationRecord
  has_many :book_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :books, through: :book_tags

  scope :merge_books, -> (tags){ }

  def self.search_books_for(method, search_word)
    if method == 'perfect'
      tags = Tag.where(name: search_word)
    elsif method == 'forward'
      tags = Tag.where('name LIKE ?', search_word + '%')
    elsif method == 'backward'
      tags = Tag.where('name LIKE ?', '%' + search_word)
    else
      tags = Tag.where('name LIKE ?', "%#{search_word}%")
    end

    return tags.inject(init = []) {|result, tag| result + tag.books}
  end
end
