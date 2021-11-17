class User < ApplicationRecord
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :name, presence: true
  validates :name, length:
    {
      minimum: Settings.length.digit_3,
      maximum: Settings.length.digit_255
    }
  validates :password, presence: true, length:
    {
      minimum: Settings.length.digit_6,
      maximum: Settings.length.digit_255
    }
  validates :password_confirmation, presence: true
  validates :email, presence: true, uniqueness: true,
    length: {maximum: Settings.length.digit_255},
    format: {with: VALID_EMAIL_REGEX}
  has_secure_password

  def self.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine.cost
            end
    BCrypt::Password.create string, cost: cost
  end

  class << self
    def User.new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end
end
