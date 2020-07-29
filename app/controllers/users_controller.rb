class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".fail_show"
    redirect_to root_path
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] =  t ".success"
      redirect_to @user
    else
      flash[:danger] = t ".fail_create"
      render :new
    end
  end

  private

  def user_params
    byebug
    params.require(:user).permit User::USERS_PARAMS
  end
end
