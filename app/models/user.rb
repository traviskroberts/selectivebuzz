require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  validates_presence_of     :name
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  validates_presence_of     :google_username
  
  before_create :make_activation_code
  before_save   :check_google_username
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :name, :password, :password_confirmation, :google_username, :twitter_enabled, :twitter_name, :twitter_token, :twitter_secret, :facebook_enabled, :facebook_uid
  
  
  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end
  
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end
  
  # Authenticates a user by their email and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  # def login=(value)
  #   write_attribute :login, (value ? value.downcase : nil)
  # end
  
  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def oauth
    @oauth ||= Twitter::OAuth.new(TwitterCredentials['token'], TwitterCredentials['secret'])
  end
  
  delegate :request_token, :access_token, :authorize_from_request, :to => :oauth
  
  def client
    @client ||= begin
      oauth.authorize_from_access(twitter_token, twitter_secret)
      Twitter::Base.new(oauth)
    end
  end
  
  protected
    def make_activation_code
        self.activation_code = self.class.make_token
    end
    
    def check_google_username
      # check to see if they put in an email address
      if google_username.include?("@")
        self.google_username = google_username.split("@").first
      end
    end
  
end
