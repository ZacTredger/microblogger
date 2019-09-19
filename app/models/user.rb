# Models a site user
class User < ApplicationRecord
  attr_accessor :activation_token
  attr_reader :remember_token
  before_create :create_activation_digest
  before_save :downcase_email
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  validates :name, presence: true, length: { maximum: 63 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@([a-z\d\-]+\.)+[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }

  class << self
    # Returns the hash digest of a passed string.
    def digest(string)
      BCrypt::Password.create(string, cost: hash_cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end

    private

    # Returns minimum possible cost in test and high cost in production
    def hash_cost
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    klass = self.class
    @remember_token = klass.new_token
    update_attribute(:remember_digest, klass.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(token, attribute = :remember)
    return false unless (digest = send "#{attribute}_digest")

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forget a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if a user will be activated by an activate_token
  def activate?(activate_token)
    !activated? && authenticated?(activate_token, :activation)
  end

  # Activate a user using an activate_token that's already been checked
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  private

  # Callbacks
  # Converts email to lower-case
  def downcase_email
    email.downcase!
  end

  # Creates and assigns the activation token and digest
  def create_activation_digest
    klass = self.class
    @activation_token = klass.new_token
    self.activation_digest = klass.digest(@activation_token)
  end
end
