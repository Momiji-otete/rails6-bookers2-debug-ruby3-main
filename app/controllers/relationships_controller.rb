class RelationshipsController < ApplicationController
  def create
    #relationship = current_user.relationships.new(followed_id: user_id)
    #relationship = Relationship.new(followed_id: user_id)
    #relationship.user_id = current_user.id
    #relationship.save
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  def followings #フォロー一覧viewを表示するアクション
    user = User.find(params[:user_id])#このparamsを:idにすると？
    @users = user.followings
  end

  def followers #フォロワー一覧viewを表示するアクション
    user = User.find(params[:user_id])
    @users = user.followers
  end
end

