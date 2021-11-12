class User < ApplicationRecord
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
end
