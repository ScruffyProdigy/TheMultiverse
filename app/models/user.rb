class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  field :nickname
         
  embeds_many :cards
  references_many :comments
  references_many :alterations  
  
  field :friends, :type => Array, :default => []
  field :sets,  :type=> Array, :default=>[]
  
  def name
    nickname
  end
  
  def make_friends(friend,logger=nil)
    self.add_friend(friend,logger)
    friend.add_friend(self,logger)
  end
  
  def sets
    ids = read_attribute(:sets)
    if ids.nil?
      ids = []
    end
    ids.map { |id| CardSet.find(id)}
  end
  
  def add_set the_set
    current = read_attribute :sets
    if current.nil?
      current = [];
    end
    current<< the_set.id
    write_attribute :sets,current
    save
  end

  def friends
    ids = read_attribute :friends
    ids.map { |id|  User.find(id)}
  end
  
  def is_friends_with? other_user
    ids = read_attribute :friends
    ids.include? other_user.id
  end
  
  def add_card the_card,logger
    logger.info("#{cards.inspect}<<#{the_card.inspect}")
    cards<<the_card
  end
  
  def find_card card_id
    return card.find(card_id)
  end
  
  def avatar size=80
    if email
      gravatar_email = email
    else
      gravatar_email = "test@gravatar.com"
    end
    return gravatar_url(gravatar_email,{:rating=>"G",:size=>size})
  end
  
protected

  def add_friend(friend,logger)
    current = read_attribute :friends
    current<< friend.id
    write_attribute :friends,current
    save
  end
  # Returns a Gravatar URL associated with the email parameter.
  #
  # Gravatar Options:
  # - rating: Can be one of G, PG, R or X. Default is X.
  # - size: Size of the image. Default is 80px.
  # - default: URL for fallback image if none is found or image exceeds rating.
  def gravatar_url(email,gravatar_options={})
    grav_url = 'http://www.gravatar.com/avatar.php?'
    grav_url << "gravatar_id=#{Digest::MD5.new.update(email)}"
    grav_url << "&rating=#{gravatar_options[:rating]}" if gravatar_options[:rating]
    grav_url << "&size=#{gravatar_options[:size]}" if gravatar_options[:size]
    grav_url << "&default=#{gravatar_options[:default]}" if gravatar_options[:default]
    return grav_url
  end

end
