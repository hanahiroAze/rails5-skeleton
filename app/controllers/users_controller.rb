class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page], :per_page => 3)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if User.with_writable { @user.save }
      helpers.log_in @user
      flash[:success] = "Welcome!"

      # redirect_to user_url(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if User.with_writable {@user.update_attributes(user_params)}
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless helpers.logged_in?
        helpers.store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless helpers.current_user?(@user)
  end
end
