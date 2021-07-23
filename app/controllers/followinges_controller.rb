class FollowingesController < ApplicationController
  before_action :logged_in_user, :load_user

  def index
    @title = t "following"
    @users = @user.following.page(params[:page]).per Settings.max_item_per_page
    render "users/show_follow"
  end
end
