class UsersController < ApplicationController
  
  extend ActiveModel::Naming

  def index
    # Added for debug only. Remove later
    @users = User.all
  end

  def new
  	@user = User.new
  end

  def update
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      sign_in @user
      # Handle a successful save.
      redirect_to 'app/views/actor/index.html.erb'
    else
      render 'new'
    end
    # redirect_to root_path
  end

  def edit
  end

  def show
  	@user = User.find(params[:id])
  end

  private
  def user_params
  	params.require(:user).permit(:name, :email)
  end
end
