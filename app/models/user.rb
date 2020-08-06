class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validation.email.regex
  USERS_PARAMS = %i(name email password password_confirmation).freeze
  attr_accessor :remember_token

  validates :name, presence: true,
    length: {maximum: Settings.validation.name.max_length}
  validates :email, presence: true,
    length: {maximum: Settings.validation.email.max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.validation.password.min_length}, allow_nil: true

  before_save :email_downcase

  has_secure_password

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create string, cost: cost
    end
  end

  def remember
    self.remember_token = User.new_token
    update :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update remember_digest: nil
  end

  private

  def email_downcase
    email.downcase!
  end
end
