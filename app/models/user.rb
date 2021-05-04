class User < ApplicationRecord
  include UniqId
  include ActiveStorageSupport::SupportForBase64
  has_one_base64_attached :image
  has_secure_password

  enum role: { customer: 0, admin: 1, vendor: 2 }

  scope :has_attached_image, -> { joins(:image_attachment) }
  scope :without_attached_image, -> {where.missing(:image_attachment)}
  
  validates :name, presence: true, length: { minimum: 3 }
  validates :role, presence: true
  validates :email,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A([a-z\d+_.-])+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    }
  validates :password, 
    presence: true,
    format: {
      with: /\A^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).{8,}$\z/,
      message: "should atleast 8 characters long and must contain: a capital letter, a lowercase letter, a number, and a special character."
    }, if: lambda{ new_record? || !password.nil? }
    
  after_initialize :setup_new_user, if: :new_record?

  def is_vendor?
    admin? || vendor?
  end

  def editable?(current_user)
    return false unless current_user
    current_user.admin? || current_user.id == self.id
  end

  def setup_new_user
    self.role ||= :customer
  end
end
