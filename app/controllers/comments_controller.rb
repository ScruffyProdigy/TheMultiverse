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
    @owner.comments<<@comment
    @owner.save
    respond_with @comment, :location=>card_comments_path(@owner)
  end
  
  def edit
    respond_with @comment
  end
  
  def update
    @comment.update_attributes(params[:comment])
    respond_with @comment, :location=>card_comments_path(@owner)
  end
  
  def destroy
    @comment.delete
    respond_with @comment, :location=>card_comments_path(@owner)
  end
  
  protected
  def test_type type
    string_type = type.to_s
    symbol_type = (string_type + '_id').to_sym
    class_type = string_type.capitalize.constantize
    
    if params[symbol_type]
      @owner_type = type
      @owner = class_type.find(params[symbol_type])
    end
  end
  
  def find_owner
    @owner_type = nil
    @owner = nil
    
    test_type :card
    
    return @owner
  end
  
  def find_comment
    logger.info "finding owner"
    if @owner.nil?
      logger.info "owner not found"
      redirect_to root_path, :alert=>"invalid comment subject"
      return
    end
    logger.info "owner found"
    @comment = @owner.comments.find(params[:id])
    logger.info "finding comment"
    if @comment.nil?
      logger.info "comment not found"
      redirect_to card_comments_path(@owner), :alert=>"comment not found"
      return
    end
    logger.info "comment found - #{@comment.text}"
  end
  
end