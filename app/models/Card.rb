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
end
