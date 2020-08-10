class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
    save_micropost @micropost
  end

  def update; end

  def destroy
    @micropost.destroy
    flash[:success] = t ".micropost_deleted"
    redirect_to request.referer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_PARAMS
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url unless @micropost
  end

  def save_micropost micropost
    if micropost.save
      flash[:success] = t ".micropost_created"
      redirect_to root_url
    else
      flash[:danger] = t ".micropost_fail"
      @feed_items = feed_posts
      render "static_pages/home"
    end
  end

  def feed_posts
    current_user.feed.create_post_at.page params[:page]
  end
end
