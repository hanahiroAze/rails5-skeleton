class HomeController < ApplicationController
  def index
    if helpers.logged_in?
      @micropost = helpers.current_user.microposts.build
      @feed_items = helpers.current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
