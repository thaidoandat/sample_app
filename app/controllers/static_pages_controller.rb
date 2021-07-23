class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.recent_posts.page(params[:page])
                              .per Settings.micropost.one_page
  end

  def help; end

  def contact; end

  def about; end
end
