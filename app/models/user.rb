class User < ApplicationRecord
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

  private

  def downcase_email
    email.downcase!
  end
end
