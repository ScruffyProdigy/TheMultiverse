class Card
  include Mongoid::Document
  field :title, :type => String
  field :cost, :type => String
  field :type, :type => String
  field :rarity, :type => String
  field :ability, :type => String
  field :flavor_text, :type => String
  field :power, :type => String
  field :toughness, :type => String
end
