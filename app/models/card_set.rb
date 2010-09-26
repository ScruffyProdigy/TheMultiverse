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