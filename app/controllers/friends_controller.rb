class FriendsController < ApplicationController
  before_filter :find_user
  before_filter :find_friend, :only=>[:show,:edit,:update,:destroy]
  
  respond_to :html, :xml, :json
  
  def index
    respond_with(@friends = @user.friends)
  end
  
  def show
    redirect_to @friend
  end
  
  def create
    current_user.friends<<@user
    current_user.save
    @user.friends<<current_user
    @user.save
    redirect_to @user
  end
  
  def destroy
    if current_user == @friend
      current_user.friends.delete @user
      current_user.save
      @user.friends.delete current_user
      @user.save
    end
    redirect_to @user
  end
  
  protected
  
  def find_user
    @user = User.find(params[:user_id])
    if @user.nil?
      redirect_to root_path
    end
  end
  
  def find_friend
    @friend = @user.friends.find(params[:id])
    if @friend.nil?
      redirect_to friends_path
    end
  end
  
end