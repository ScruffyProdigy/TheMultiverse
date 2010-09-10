class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  references_many :cards
  references_many :comments
#  references_many :users, :stored_as => :array, :inverse_of => :users #represents friends - mongoid doesn't have good support for references_many yet
  references_many :revisions
  
  def friends
    users
  end
  
  def is_friends_with? other_user
    friends.include? other_user
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
