class BooksController < ApplicationController
  #コメントは解説を見てから修正を加えた部分、並びに説明を記載
  before_action :is_matching_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    #ここで@book.userを渡すよりrenderでuserに@book.userを渡すほうが無駄なエラーを防げる気がする
    #@user = @book.user
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    # @books = Book.all.sort_by{ |books| [books.favorites.count] }.reverse
    @books = Book.fav_sorting
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.fav_sorting
      render 'index'
    end
  end

  def edit
    #@book = Book.find(params[:id])
  end

  def update
    #@book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    #@book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_user
    #ここを@bookにすることでedit、update、destroyのfindメソッドを消すことができる
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  # def fav_sorting
  #   @order = Favorite.group(:book_id).where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day)
  #   # @order.order('count(book_id) desc').pluck(:book_id)
  #   #Book.find(@order)
  # end

  # def fav_ordering
  #   Book.joins(:favorites).group(:book_id).where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day).order('count(user_id) desc')
  # end

  # def fav_sorting
  #   Book.all.sort_by{ |books| [books.favorites.count] }.reverse
  # end
end
