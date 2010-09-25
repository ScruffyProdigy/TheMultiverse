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

class CardSet
  include Mongoid::Document
  include MongoidArrayHelper
  
  field :name
  field :editors,       :type=>Array, :default=>[]    #users who are allowed to edit this set
  
  embeds_many :card_slots
  embeds_many :cards
  
  def add_slots slot_count
    slot_count.times do
      slot = CardSlot.new
      card_slots<<slot
      slot.save
    end
  end
  
  def add_card the_card
    the_card.status = 'submitted'
    cards<<the_card
    the_card.save
    save
  end
  
  def cut_card the_card
    the_card = cards.find(the_card)
    the_card.status = 'cut'
    the_card.save
  end
  
  def resubmit_card the_card
    the_card = cards.find(the_card)
    the_card.status = 'submitted'
    the_card.save
  end
  
  def add_editor the_user
    add_to_array :editors,the_user.id
    save
    the_user.add_set self
  end
  
  def editors
    map_array :editors,User
  end
  
  def can_view? the_user
    if the_user.nil?
      return false
    end
    editors = read_array :editors
    editors.include? the_user.id
  end
  
  def can_edit? the_user
    if the_user.nil?
      return false
    end
    editors = read_array :editors
    editors.include? the_user.id
  end
  
end