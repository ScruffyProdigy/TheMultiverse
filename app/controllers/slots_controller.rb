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
    for_param(:card_slot,:tag_name) do |new_tag|
      @slot.add_tag new_tag
    end
    
    #check for deleted tags
    for_param(:card_slot,:deleted_tag) do |deleted_tag|
      logger.info("deleting tag: #{deleted_tag}")
      @slot.remove_tag deleted_tag
    end
    
    #check for cards being slotted
    for_param(:card_slot,:card) do |new_card|
      @slot.slot_card new_card
    end
    
    #check for cards being unslotted
    for_param(:card_slot,:cut) do |cut_card|
      @slot.cut_card cut_card
    end
    
    #check for unslotted cards
    for_param(:card_slot,:unslot) do |unslot_card|
      @slot.unslot_card unslot_card
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