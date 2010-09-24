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
  
  referenced_in :user
  embeds_many :comments
  embeds_many :alterations
  embedded_in :owner, :inverse_of=>:card
  
  scope :submitted, where(:status=>'submitted')
  scope :slotted, where(:status=>'slotted')
  scope :cut, where(:status=>'cut')
  
  before_update :register_changes
  
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
      if self.type.downcase.includes? 'land'
        return 'land'
      end
      if self.type.downcase.includes? 'artifact'
        return 'artifact'
      end
      return 'purple'
    end
    return frame
  end
end
