class BooksController < ApplicationController
  #コメントは解説を見てから修正を加えた部分、並びに説明を記載
  before_action :is_matching_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
  end

  def index
    @book = Book.new
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
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
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

end
