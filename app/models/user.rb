class User < ApplicationRecord
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }
  validates :name, presence: true, length: { maximum: 63 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@([a-z\d\-]+\.)+[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  before_save { email.downcase! }

  # Returns the hash digest of a passed string
  def self.digest(string)
    BCrypt::Password.create(string, cost: hash_cost)
  end

  # Returns minimum possible cost in test and high cost in production
  def self.hash_cost
    if ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
  end
end
