class GroupUsersController < ApplicationController
  def create
    group = Group.find(params[:group_id])
    current_user.group_users.create(group_id: group.id)
    redirect_to groups_path
  end

  def destroy
    group = Group.find(params[:group_id])
    group_user = current_user.group_users.find_by(group_id: group.id)
    group_user.destroy
    redirect_to groups_path
  end
end
