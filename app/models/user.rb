class User < ApplicationRecord
  has_secure_password
  validates :password, presence: true, length: { minimum: 9 }
  validates :name, presence: true, length: { maximum: 63 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@([a-z\d\-]+\.)+[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  before_save { email.downcase! }
end
