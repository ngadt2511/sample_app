class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validation.email.regex
  USERS_PARAMS = %i(name email password password_confirmation).freeze

  validates :name, presence: true,
    length: {maximum: Settings.validation.name.max_length}
  validates :email, presence: true,
    length: {maximum: Settings.validation.email.max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.validation.password.min_length}

  before_save :email_downcase

  has_secure_password

  private

  def email_downcase
    email.downcase!
  end
end
