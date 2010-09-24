class Alteration
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :the_changes, :type=>Array
  embedded_in :card, :inverse_of=>:alterations
  referenced_in :user
  
  def self.save_changes object_changed=nil,revisioner=nil
    if object_changed.nil? or object_changed.changes.nil? or object_changed.changes.empty?
      return
    end
    the_alteration = Alteration.new
    the_alteration.the_changes = object_changed.changes.to_a
    the_alteration.user = revisioner
    object_changed.alterations<<the_alteration
    the_alteration.save
  end
  
  def <=>(other)
    self.created_at <=> other.created_at
  end
end