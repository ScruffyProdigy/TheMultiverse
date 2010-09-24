class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :text
  field :created_at, :type => Time 
  field :updated_at, :type => Time
  
  embedded_in :owner, :inverse_of=>:comments
  referenced_in :user
  
  def route
    result = ['',owner.class.to_s.downcase.pluralize, owner.id, 'comments', id].join '/'
  end
  
  def descendancy
    result = [owner,self]
  end
  
  def self.owner_types
    ['cards']
  end
  
  def start_save options={}
    options = {:create=>false}.merge options
    
    if options[:create]
      set_created_at
    end
    set_updated_at

  end
  
  def <=> other
    self.created_at <=> other.created_at
  end
end
