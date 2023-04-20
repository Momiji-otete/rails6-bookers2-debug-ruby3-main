class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    book = Book.find(params[:book_id])
    @favorite = current_user.favorites.new(book_id: book.id)
    @favorite.save
    # redirect_back(fallback_location: root_path)
    # redirect_to request.referer
    @books = Book.fav_sorting
  end

  def destroy
    book = Book.find(params[:book_id])
    @favorite = current_user.favorites.find_by(book_id: book.id)
    @favorite.destroy
    # redirect_back(fallback_location: root_path)
    # redirect_to request.referer
    @books = Book.fav_sorting
  end
  
  private
  
  # def fav_sorting
  #   Book.all.sort_by{ |books| [books.favorites.count] }.reverse
  # end

end
