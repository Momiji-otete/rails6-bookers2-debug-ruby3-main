class ChatsController < ApplicationController
  def create
    if Entry.where(user_id: current_user.id, room_id: params[:chat][:room_id]).present?
      @message = Chat.create(params.require(:chat).permit(:user_id, :message, :room_id).merge(user_id: current_user.id))
      # @message = current_user.chats.new(chat_params)
      # @message.save
    else
      flash[:notice] = "メッセージ送信に失敗しました。"
    end
    redirect_back(fallback_location: root_path)
  end


  private
  def chat_params
    params.require(:chat).permit(:user_id, :message, :room_id)
  end
end
