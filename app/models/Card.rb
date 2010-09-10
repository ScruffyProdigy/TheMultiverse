class Card
  include Mongoid::Document
  field :title
  field :cost
  field :type
  field :rarity
  field :ability
  field :flavor_text
  field :power
  field :toughness
  
  referenced_in :user
  embeds_many :comments
  embeds_many :alterations
  
  before_save :register_changes
  
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
    result.sort!{|a,b|a.created_at <=> b.created_at}
  end
end
