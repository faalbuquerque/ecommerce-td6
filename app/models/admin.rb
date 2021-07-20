class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, :registerable,
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  VALID_DOMAIN = ['@mercadores.com.br'].freeze

  validate :check_email

  before_validation :set_password_default, on: :create

  private

  def set_password_default
    return if password.present?

    prefix_email = "#{email.split('@').first}123456"
    self.password = prefix_email
  end

  def check_email
    return if email.blank?

    errors.add(:email, 'não é válido') unless VALID_DOMAIN.any? { |domain| email.include?(domain) }
  end
end
