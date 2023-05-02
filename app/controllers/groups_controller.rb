class GroupsController < ApplicationController
  before_action :matching_correct_user, only: [:edit, :update]
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      current_user.group_users.create(group_id: @group.id)
      redirect_to groups_path
    else
      render :new
    end

  end

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @users = @group.users
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit
    end
  end

  def event_email
    @group = Group.find(params[:group_id])
  end

  def send_email
    group = Group.find(params[:group_id])
    users = group.users
    @email_title = params[:email_title]
    @email_body = params[:email_body]
    UserMailer.send_email(@email_title, @email_body, users).deliver
  end

  private
  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def matching_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
