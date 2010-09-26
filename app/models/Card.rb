class Card
  include Mongoid::Document
  field :title
  field :cost
  field :type
  field :picture
  field :rarity
  field :ability
  field :flavor_text
  field :power
  field :toughness
  field :status
  field :favor
  
  field :slot
  
  referenced_in :user
  embeds_many :comments
  embeds_many :alterations
  embedded_in :owner, :inverse_of=>:card
  
  scope :submitted, where(:status=>'submitted')
  scope :slotted, where(:status=>'slotted')
  scope :cut, where(:status=>'cut')
  
  before_update :register_changes
  
  def slot
    slot_id = read_attribute :slot
    owner.card_slots.find(slot_id)
  end
  
  def slot= the_slot
    if the_slot.nil?
      write_attribute :slot,nil
    else
      write_attribute :slot,the_slot.id
    end
  end
  
  def unslot_card
    the_slot = slot
    unless the_slot.nil?
      the_slot.remove_card self
      slot = nil
    end
  end
  
  def set_status new_status
    unslot_card
    write_attribute :status,new_status
  end
  
  def slot_card the_slot
    set_status 'slotted'
    write_attribute :slot,the_slot.id
    the_slot.add_card self
  end
  
  def submit_card
    set_status 'submitted'
  end
  
  def cut_card
    set_status 'cut'
  end
  
  def updater= last_updater
    @updater = last_updater
  end
  
  def updater
    @updater
  end
  
  def register_changes
    Alteration.save_changes(self,@updater)
  end
  
  def editor_permissions? the_user
    if the_user == user
      return true
    else
      return false
    end
  end
  
  def viewer_permissions? the_user
    return true
  end
  
  def events
    result = comments + alterations
    result.sort!{|a,b|a.created_at<=>b.created_at}
  end
  
  def get_frame
    frame = ''
    colors = {'w'=>'white','u'=>'blue','b'=>'black','r'=>'red','g'=>'green'}
    if self.cost
      self.cost.each_char do |c|
        color = colors[c.downcase]
        if color
          if frame == '' or frame == color
            frame = color
          else
            frame = 'multicolor'
          end
        end
      end
    end
    if frame == ''
      if self.type.downcase.include? 'land'
        return 'land'
      end
      if self.type.downcase.include? 'artifact'
        return 'artifact'
      end
      return 'purple'
    end
    return frame
  end
end
