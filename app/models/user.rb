class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :addresses, dependent: :destroy
  has_many :carts, dependent: :destroy
<<<<<<< HEAD
  has_many :returns, dependent: :destroy
=======
  has_many :evaluations, dependent: false
>>>>>>> 60867a80073ed164e517c0158fef15c8538428bc
end
