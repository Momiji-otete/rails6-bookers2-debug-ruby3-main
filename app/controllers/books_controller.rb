class BooksController < ApplicationController
  #コメントは解説を見てから修正を加えた部分、並びに説明を記載
  before_action :is_matching_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    #ここで@book.userを渡すよりrenderでuserに@book.userを渡すほうが無駄なエラーを防げる気がする
    #@user = @book.user
  end

  def index
    @book = Book.new
    @books = Book.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
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
end
