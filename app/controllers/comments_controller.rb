class CommentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :find_comment, :only=>[:show,:edit,:update,:destroy]
  
  respond_to :html, :xml, :json
  
  def index
    respond_with(@comments = @parents[0].comments)
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
    @parents[0].comments<<@comment
    @comment.start_save(:create=>true)
    @parents[0].save
    respond_with @comment, :location=>@parents.reverse
  end
  
  def edit
    respond_with @comment
  end
  
  def update
    @comment.start_save
    @comment.update_attributes(params[:comment])
    respond_with @comment, :location=>@parents.reverse
  end
  
  def destroy
    @comment.delete
    respond_with @comment, :location=>@parents.reverse
  end
  
  protected
  
  def find_comment
    @comment = @parents[0].comments.find(params[:id])
    if @comment.nil?
      redirect_to @parents.reverse, :alert=>"comment not found"
      return
    end
  end
  
end