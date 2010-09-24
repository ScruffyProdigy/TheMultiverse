class SlotsController < ApplicationController
  before_filter :find_slot, :only=>[:show,:edit,:update,:destroy]
  
  respond_to :html, :xml, :json
  
  def index
    respond_with(@slots = @parents[0].card_slots)
  end
  
  def show
    respond_with @slot
  end
  
  def new
    @slot = Slot.new
    respond_with @slot
  end
  
  def create
    @slot = CardSlot.create(params[:card_slot])
    respond_with @slot, :location=>@parents[0]
  end
  
  def edit
    respond_with @slot
  end
  
  def update
    #check for new tags
    new_tag = params[:card_slot].delete(:tag_name)
    unless new_tag.nil?
      @slot.add_tag new_tag
    end
    
    #check for deleted tags
    deleted_tag = params[:card_slot].delete(:deleted_tag)
    unless deleted_tag.nil?
      @slot.remove_tag deleted_tag
    end
    
    #check for cards being slotted
    new_card = params[:card_slot].delete(:card)
    unless new_card.nil?
      @slot.slot_card new_card
    end
    
    #check for cards being unslotted
    cut_card = params[:card_slot].delete(:cut)
    unless cut_card.nil?
      @slot.cut_card cut_card
    end
    
    @slot.update_attributes(params[:card_slot])
    respond_with @slot, :location=>url_for(@parents.reverse)+'/slots'
  end
  
  def destroy
    @slot.destroy
    respond_with @slot, :location=>@parents[0]
  end
  
  protected
  def find_slot
    @slot = @parents[0].card_slots.find(params[:id])
    if @slot.nil?
      redirect_to slots_path
    end
  end
  
end