class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  before_action :build_micropost, only: :create

  def create
    if @micropost.save
      flash[:success] = t "micropost_created"
      return redirect_to root_url
    end

    @feed_items = current_user.feed.recent_posts.page(params[:page])
                              .per Settings.micropost.one_page
    flash[:danger] = t "micropost_created_fail"
    render "static_pages/home"
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to request.referer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_PARAMS
  end

  def correct_user
    @micropost = current_user.microposts.recent_posts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "micropost_invalid"
    redirect_to request.referer || root_url
  end

  def build_micropost
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
  end
end
