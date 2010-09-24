class SetsController < ApplicationController
  before_filter :find_set, :only=>[:show,:edit,:update,:destroy]
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :ensure_editor_permissionship!, :only => [:edit, :update, :destroy]
  before_filter :ensure_viewing_permissionship!, :only => [:show]
  
  respond_to :html, :xml, :json
  
  def index
    respond_with(@sets = CardSet.all)
  end
  
  def show
    respond_with @set
  end
  
  def new
    @set = CardSet.new
    respond_with @set
  end
  
  def create
    @set = CardSet.new(params[:card_set])
    @set.save
    @set.add_editor current_user
    respond_with @set
  end
  
  def edit
    respond_with @set
  end
  
  def update
    new_slots = params[:card_set].delete(:new_slots)
    unless new_slots.nil?
      new_slots.to_i.times do
        slot = CardSlot.new
        @set.card_slots<<slot
        slot.save
      end
    end
    @set.update_attributes(params[:card_set])
    respond_with @set
  end
  
  def destroy
    @set.destroy
    respond_with @set, :location=>sets_path
  end
  
  protected
  def find_set
    @set = CardSet.find(params[:id])
    if @set.nil?
      redirect_to sets_path
    end
  end
  
  def ensure_editor_permissionship!
    unless @set.can_edit? current_user
      logger.info "insufficient editing permissions"
      redirect_to root_path
    end
  end
  
  def ensure_viewing_permissionship!
    unless @set.can_view? current_user
      logger.info "insufficent viewing permissions"
      redirect_to root_path
    end
  end
  
end