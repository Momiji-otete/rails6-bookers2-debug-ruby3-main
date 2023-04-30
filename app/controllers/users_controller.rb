class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

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

    @data = {
      'today' => @books.created_today.size,
      'yesterday' => @books.created_yesterday.size,
      '2days_ago' => @books.created_2days_ago.size,
      '3days_ago' => @books.created_3days_ago.size,
      '4days_ago' => @books.created_4days_ago.size,
      '5days_ago' => @books.created_5days_ago.size,
      '6days_ago' => @books.created_6days_ago.size,
      'this_week' => @books.created_this_week.size,
      'last_week' => @books.created_last_week.size
    }

    @rate_yesterday = (@data['today'] / @data['yesterday']) * 100 unless @data['yesterday'] == 0
    @rate_last_week = (@data['this_week'] / @data['last_week']) * 100 unless @data['last_week'] == 0



  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    user = User.find(params[:id])
    unless user == current_user
      redirect_to user_path(current_user)
    end
  end

end
