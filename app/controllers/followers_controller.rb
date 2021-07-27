class FollowersController < ApplicationController
  before_action :logged_in_user, :load_user

  def index
    @title = t "follower"
    @users = @user.followers.page(params[:page]).per Settings.max_item_per_page
  end
end
