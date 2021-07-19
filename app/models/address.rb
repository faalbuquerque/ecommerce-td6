class Address < ApplicationRecord
  belongs_to :user
  validates :state, :city, :cep, :neighborhood, :street, :number, presence: true
end
