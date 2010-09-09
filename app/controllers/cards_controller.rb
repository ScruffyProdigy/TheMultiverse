class CardsController < ApplicationController
  before_filter :find_card, :only=>[:show,:edit,:update,:destroy]
  
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
    @card = Card.create(params[:card])
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
    respond_with @card
  end
  
  protected
  def find_card
    @card = Card.find(params[:id])
    if @card.nil?
      redirect_to :action=>:index
    end
  end
end