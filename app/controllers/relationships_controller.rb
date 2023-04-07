class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  def create
    #current_user.follow(params[:user_id])
    user = User.find(params[:user_id])
    current_user.follow(user)
    redirect_to request.referer
  end

  def destroy
    # current_user.unfollow(params[:user_id])
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to request.referer
  end

  def followings #フォロー一覧viewを表示するアクション
    user = User.find(params[:user_id])
    @users = user.followings
  end

  def followers #フォロワー一覧viewを表示するアクション
    user = User.find(params[:user_id])
    @users = user.followers
  end
end

