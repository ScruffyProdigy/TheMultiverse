class UsersController < ApplicationController
  before_filter :find_user, :only=>[:show,:edit,:update,:destroy]
  
  respond_to :html, :xml, :json
  
  def index
    respond_with(@users = User.all)
  end
  
  def show
    respond_with @user
  end
  
  def new
    @user = User.new
    respond_with @user
  end
  
  def create
    @user = User.new(params[:user])
    @user.nickname = @user.email
    @user.save
    respond_with @user
  end
  
  def edit
    respond_with @user
  end
  
  def update
    #check to see if the update was a friend request
    if params[:user] == "friend_me"
      unless @user.is_friends_with? current_user
        logger.info("let's make friends!")
        @user.make_friends(current_user,logger)
      end
      respond_with @user
      return
    end
    
    @user.attributes = params[:user]
    if @user.nickname.nil? or @user.nickname == ""
      @user.nickname = @user.email
    end
    @user.save
    respond_with @user
  end
  
  def destroy
    @user.destroy
    respond_with @user, :location=>users_path
  end
  
  protected
  def find_user
    @user = User.find(params[:id])
    if @user.nil?
      redirect_to users_path
    end
  end
  
end