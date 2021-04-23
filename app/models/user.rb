class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, length: { minimum: 3 }
  validates :email,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A([a-z\d+_.-])+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    }
  validates :password, presence: true, length: { minimum: 3 }
end
