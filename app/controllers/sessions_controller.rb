class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    valid_password = user&.authenticate params[:session][:password]
    return login user if valid_password

    flash.now[:danger] = t "error_login"
    render :new
  end

  def destroy
    log_out if logged_in?

    redirect_to root_url
  end

  def login user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_to user
  end
end
