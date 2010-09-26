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
      @slot.save
      respond_with @slot, :location=>@slot.card_set
      return
    end
    
    #check for deleted tags
    for_param(:card_slot,:deleted_tag) do |deleted_tag|
      @slot.remove_tag deleted_tag
      @slot.save
      respond_with @slot, :location=>@slot.card_set
      return
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