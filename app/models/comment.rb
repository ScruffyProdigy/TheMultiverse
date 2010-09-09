class Comment
  include Mongoid::Document
  field :text
  
  embedded_in :owner, :inverse_of=>:comments
end
