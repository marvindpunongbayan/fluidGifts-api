class User < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64
  has_one_base64_attached :image

  has_secure_password

  scope :has_attached_image, -> { joins(:image_attachment) }
  
  validates :name, presence: true, length: { minimum: 3 }
  validates :email,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A([a-z\d+_.-])+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    }
  validates :password, presence: true, length: { minimum: 3 }
end
