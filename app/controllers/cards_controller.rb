class CardsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :find_card, :only=>[:show,:edit,:update,:destroy]
  before_filter :ensure_editor_permissionship!, :only => [:edit, :update, :destroy]
  before_filter :ensure_viewing_permissionship!, :only => [:show]
  
  respond_to :html, :xml, :json
  
  def index
    respond_with(@cards = Card.all)
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
    @card.save
    respond_with @card
  end
  
  def edit
    respond_with @card
  end
  
  def update
    @card.update_attributes(params[:card])
    respond_with @card
  end
  
  def destroy
    @card.destroy
    respond_with @card, :location=>cards_path
  end
  
  protected
  def find_card
    @card = Card.find(params[:id])
    if @card.nil?
      redirect_to cards_path
    end
  end
  
  def ensure_editor_permissionship!
    if !@card.editor_permissions? current_user
      redirect_to card_path, :alert=>"you don't have permission to do that"
    end
  end
  
  def ensure_viewing_permissionship!
    if !@card.viewer_permissions? current_user
      redirect_to cards_path, :alert=>"this card is private"
    end
  end
  
end