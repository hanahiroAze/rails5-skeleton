class HomeController < ApplicationController
  def index
    @micropost = helpers.current_user.microposts.build if helpers.logged_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
