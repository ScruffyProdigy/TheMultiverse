class Card
  include MongoMapper::Document
  
  key :title, String
  key :cost, String
  key :type, String
  key :rarity, String
  key :ability, String
  key :flavor_text, String
  key :power, String
  key :toughness, String
end