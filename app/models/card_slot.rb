class CardSlot
  include Mongoid::Document
  include MongoidArrayHelper
  field :name #Usually something like Green Uncommon Non-Creature #5
  field :tags, :type=>Array   #array of strings
  field :cards, :type=>Array  #list of cards filling this slot
  
  def add_tag tag
    add_to_array :tags,tag
    save
  end
  
  def remove_tag tag
    remove_from_array :tags,tag
    save
  end
  
  def slot_card card
    card = card_set.cards.find(card)
    card.status = 'slotted'
    card.save

    add_to_array :cards,card.id
    save
  end
  
  def cut_card card
    card = card_set.cards.find(card)
    result = remove_from_array :cards,card.id
    save
    
    unless result.nil?
      card.status = 'cut'
      card.save
    end
  end

  def unslot_card card
    card = card_set.cards.find(card)
    result = remove_from_array :cards,card.id
    save

    unless result.nil?
      card.status = 'submitted'
      card.save
    end
  end
  
  def cards
    map_array :cards,card_set.cards
  end

  def status
    case cards.count
    when 0
      result = 'underslotted'
    when 1
      result = 'filled'
    else
      result = 'overslotted'
    end
    return result
  end
  
  embedded_in :card_set, :inverse_of=>:card_slot
end