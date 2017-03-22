class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  included SessionsHelper

  private
    def logged_in_user
      unless helpers.logged_in?
        helpers.store_location
        flash.now[:danger] = "Please log in"
        redirect_to login_url
      end
    end
end
