class User < ApplicationRecord
  has_one :car_detail, dependent: :destroy

  has_secure_password
  has_many :supports, dependent: :destroy
  has_many :mobile_devices, dependent: :destroy
  has_many :quick_chats, dependent: :destroy
  has_one_attached :image, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
  validates :contact, presence: true, uniqueness: true
  enum status: [:active, :disabled]
end
