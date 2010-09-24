

class CardSlot
  include Mongoid::Document
  field :name #Usually something like Green Uncommon Non-Creature #5
  field :tags, :type=>Array   #array of strings
  field :cards, :type=>Array  #list of cards filling this slot
  
  def add_tag tag
    current = read_attribute :tags
    if current.nil?
      current = []
    end
    current << tag
    write_attribute :tags,current
    save
  end
  
  def remove_tag tag
    
  end
  
  def slot_card card
    card = card_set.cards.find(card)
    card.status = 'slotted'
    card.save
    
    current = read_attribute :cards
    if current.nil?
      current = []
    end
    current << card.id
    write_attribute :cards,current
    save
  end
  
  def cut_card card
    
  end
  
  def cards
    ids = read_attribute :cards
    if ids.nil?
      ids = []
    end
    ids.map {|id| card_set.cards.find(id)}
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
  
  field :name
  field :editors,       :type=>Array, :default=>[]    #users who are allowed to edit this set
  
  embeds_many :card_slots
  embeds_many :cards
  
  
  def add_card the_card,logger
    the_card.status = 'submitted'
    cards<<the_card
    the_card.save
    save
  end
  
  def add_editor the_user
    current = read_attribute :editors
    if current.nil?
      current = []
    end
    current<< the_user.id
    write_attribute :editors,current
    save
    the_user.add_set self
  end
  
  def editors
    ids = read_attribute :editors
    ids.map{ |id| User.find(id)}
  end
  
  def can_view? the_user
    editors = read_attribute :editors
    if editors.nil?
      editors = []
    end
    editors.include? the_user.id
  end
  
  def can_edit? the_user
    editors = read_attribute :editors
    if editors.nil?
      editors = []
    end
    editors.include? the_user.id
  end
  
end