class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      helpers.log_in user
      params[:session][:remember_me] == '1' ? helpers.remember(user) : helpers.forget(user)
      helpers.redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    helpers.log_out if helpers.logged_in?
    redirect_to root_url
  end
end
