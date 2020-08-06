class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      remember_user user
    else
      flash.now[:danger] = t ".danger"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def remember_user user
    log_in user
    if params[:session][:remember_me] == Settings.checkbox
      remember user
    else
      forget user
    end
    redirect_back_or user
  end
end
