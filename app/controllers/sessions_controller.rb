class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        helpers.log_in user
        params[:session][:remember_me] == '1' ? helpers.remember(user) : helpers.forget(user)
        redirect_back_or user
      else
        message = 'Account not activated'
        message += 'Check your email for the activation link'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    helpers.log_out if helpers.logged_in?
    redirect_to root_url
  end

  private
    def redirect_back_or(default)
      redirect_to(session[:forwarding_url] || default)
      session.delete(:forwarding_url)
    end
end
