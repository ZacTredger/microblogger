# Models a site user
class User < ApplicationRecord
  attr_reader :remember_token
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  validates :name, presence: true, length: { maximum: 63 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@([a-z\d\-]+\.)+[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  before_save { email.downcase! }

  # Remembers a user in the database for use in persistent sessions.
  def remember
    klass = self.class
    @remember_token = klass.new_token
    update_attribute(:remember_digest, klass.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    remember_digest &&
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forget a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

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
end
