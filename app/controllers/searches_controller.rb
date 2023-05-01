class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model_name = params[:model_name]
    @method = params[:method]
    @search_word = params[:search_word]

    if @model_name == "user"
      @users = User.search_for(@method, @search_word)
    else
      @books = Book.search_for(@method, @search_word)
    end
  end

end
