class CommentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :find_owner
  before_filter :find_comment, :only=>[:show,:edit,:update,:destroy]
  
  respond_to :html, :xml, :json
  
  def index
    respond_with(@comments = @owner.comments)
  end
  
  def show
    respond_with @comment
  end
  
  def new
    @comment = Comment.new
    respond_with @comment
  end
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @owner.comments<<@comment
    #begin the following two lines of code are to make up for the fact that Mongoid::Timestamps don't save when they are supposed to
    @comment.set_created_at
    @comment.set_updated_at
    #end
    @owner.save
    respond_with @comment, :location=>@owner
  end
  
  def edit
    respond_with @comment
  end
  
  def update
    #begin the following line of code is to make up for the fact that Mongoid::Timestamps don't save when they are supposed to
    @comment.set_updated_at
    #end 
    @comment.update_attributes(params[:comment])
    respond_with @comment, :location=>@owner
  end
  
  def destroy
    @comment.delete
    respond_with @comment, :location=>@owner
  end
  
  protected
  
  def find_owner
    scrap, @owner_type, @owner_id, scrap, @comment_id= request.fullpath.split '/'
    
    unless Comment.owner_types.include? @owner_type
      redirect_to root_path, :alert=>"comment owner not found"
    end
    
    @owner = @owner_type.singularize.capitalize.constantize.find(@owner_id)
    
    if @owner.nil?
      redirect_to root_path, :alert=>"comment owner not found"
    end
  end
  
  def find_comment
    @comment = @owner.comments.find(params[:id])
    if @comment.nil?
      redirect_to @owner, :alert=>"comment not found"
      return
    end
  end
  
end