class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :login_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
  class << self              
    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
  
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
  
   # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    update_attribute(:activation_sent_at, Time.zone.now)
    UserMailer.account_activation(self).deliver_now
  end
  
  # Resends activation email.
  def resend_activation_email
    self.activation_token  = User.new_token
    update_columns(activation_digest:  User.digest(activation_token),
                   activation_sent_at: Time.zone.now)
    UserMailer.account_activation(self).deliver_now
  end
  
  # Returns true if a Activation link has expired.
  def activation_link_expired?
    activation_sent_at < 15.minutes.ago
  end
  
  # Sends login email
  def send_login_email
    create_login_digest
    UserMailer.account_login(self).deliver_now
  end
  
  # Returns true if a Login link has expired.
  def login_link_expired?
    login_sent_at < 15.minutes.ago
  end
  
  private
  
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
  
    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    
    # Creates and assigns the login token and digest.
    def create_login_digest
      self.login_token  = User.new_token
      update_columns(login_digest:  User.digest(login_token),
               login_sent_at: Time.zone.now)
    end
end