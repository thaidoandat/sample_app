class UsersController < ApplicationController
  before_action :load_user, except: %i(new create index)
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.all.page(params[:page]).per Settings.page.item_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    return render :new unless @user.save

    @user.send_activation_email
    flash[:info] = t "check_email_to_activate"
    redirect_to root_url
  end

  def show
    @microposts = @user.microposts.recent_posts.page(params[:page])
                       .per Settings.micropost.one_page
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      flash[:danger] = t "update_fail"
      render :edit
    end
  end

  def destroy
    if current_user != @user && @user.destroy
      flash[:success] = t "user_deleted"
    else
      flash[:danger] = t "deleted_failed"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
