class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = helpers.current_user.microposts.build(micropost_params)
    if Micropost.with_writable { @micropost.save }
      flash[:success] = 'Micropost created'
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    Micropost.with_writable { @micropost.destroy }
    flash[:success] = 'deleted'
    redirect_back(fallback_location: root_url)
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = helpers.current_user.microposts.find_by(id: params[:id])
      flash[:danger] = 'cant delete except you'
      redirect_to root_url if @micropost.nil?
    end
end
