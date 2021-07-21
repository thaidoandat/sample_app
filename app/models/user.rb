class User < ApplicationRecord
  attr_accessor :remember_token

  before_save :downcase_email

  validates :email, presence: true, uniqueness: {case_sensitive: false},
                    length: {
                      minimum: Settings.email.length.min,
                      maximum: Settings.email.length.max
                    },
                    format: {with: Settings.email.valid_regex}
  validates :name,  presence: true,
                    length: {
                      minimum: Settings.name.length.min,
                      maximum: Settings.name.length.max
                    }
  validates :password, presence: true,
                         length: {minimum: Settings.password.length.min},
                         if: :password

  has_secure_password

  class << self
    def digest string
      min_cost = ActiveModel::SecurePassword.min_cost
      cost = min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_token

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
