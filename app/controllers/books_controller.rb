class BooksController < ApplicationController
  before_action :is_matching_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end

    current_user_entries = Entry.where(user_id: current_user.id)
    user_entries = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      current_user_entries.each do |current_user_entry|
        user_entries.each do |user_entry|
          if current_user_entry.room_id == user_entry.room_id
            @isRoom = true
            @roomId = current_user_entry.room_id
          end
        end
      end
      unless @isRoom
        @room = Room.new
        @entry = Entry.new
      end
    end

  end

  def index
    unless params[:sort]
      to = Time.current.at_end_of_day
      from = (to - 6.day).at_beginning_of_day
      @books = Book.all.sort {|a,b|
        b.favorites.where(created_at: from...to).size <=>
        a.favorites.where(created_at: from...to).size
      }
      # @books = Book.includes(:favorites).sort_by {|x| x.favorites.where(created_at: from...to).size}.reverse
    else
      @books = Book.all.order(params[:sort])
    end
    @book = Book.new
  end


  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    tag_list = params[:book][:tag_name].split(',')
    if @book.save
      @book.save_tags(tag_list)
      byebug
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    tag_list = params[:book][:tag_name].split(',')
    if @book.update(book_params)
      @book.save_tags(tag_list)
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
    params.require(:book).permit(:title, :body, :rate)
  end

  def is_matching_user
    #ここを@bookにすることでedit、update、destroyのfindメソッドを消すことができる
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

end
