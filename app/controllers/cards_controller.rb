class CardsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :find_owner
  before_filter :find_card, :only=>[:show,:edit,:update,:destroy]
  before_filter :ensure_editor_permissionship!, :only => [:edit, :update, :destroy]
  before_filter :ensure_viewing_permissionship!, :only => [:show]
  
  respond_to :html, :xml, :json
  
  def index
    logger.info "making it to Cards#index"
    if @parents[0].nil?
      respond_with(@cards = [])
    else
      respond_with(@cards = @parents[0].cards)
    end
  end
  
  def show
    respond_with @card
  end
  
  def new
    @card = Card.new
    respond_with @card
  end
  
  def create
    @card = Card.new(params[:card])
    @card.user = current_user
    @card.updater = current_user
    @parents[0].add_card @card
    @card.save
    respond_with @card, :location=>@parents.reverse.push(@card)
  end
  
  def edit
    respond_with @card
  end
  
  def update
    @card.updater = current_user
    
    for_param(:card,:submit) do
      @card.submit_card
      @card.save
    end
    
    for_param(:card,:cut) do
      @card.cut_card
      @card.save
    end
    
    for_param(:card,:slot) do |slot_id|
      slot = @card.owner.card_slots.find(slot_id)
      @card.slot_card slot
      @card.save
    end
    
    @card.attributes = params[:card]
    @card.save
    respond_with @card, :location=>@parents.reverse.push(@card)
  end
  
  def destroy
    @card.destroy
    respond_with @card, :location=>@parents.reverse
  end
  
  protected
  
  def find_owner
    if @parents[0].nil?
      if user_signed_in?
        @parents[0] = current_user
      else
        logger.info("owner not found")
        redirect_to root_path
      end
    end
  end
  
  def find_card
    collection = @parents[0].cards
    @card = collection.find(params[:id])
    if @card.nil?
      logger.info("card not found in #{@parents[0].inspect}")
      redirect_to root_path
    end
  end
  
  def ensure_editor_permissionship!
    if !@card.editor_permissions? current_user
      logger.info("insufficient editing permissions")
      redirect_to root_path, :alert=>"you don't have permission to do that"
    end
  end
  
  def ensure_viewing_permissionship!
    if !@card.viewer_permissions? current_user
      logger.info("insufficient viewing permissions")
      redirect_to root_path, :alert=>"this card is private"
    end
  end
  
end