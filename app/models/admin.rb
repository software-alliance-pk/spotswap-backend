class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum category: [:admin, :sub_admin]
  enum status: {active: 'active', disabled: 'disabled'}
  has_many :support_conversations, dependent: :destroy, foreign_key: :recipient_id

  has_one_attached :image, dependent: :destroy
  self.per_page = 10

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  validates :full_name, :category, presence: true
  validate :image_content_type, if: -> { image.attached? }
  
  private

  def image_content_type
    unless image.content_type.in?(%w(image/png image/gif image/jpeg))
      errors.add(:image, 'must be a PNG, GIF, or JPEG image')
    end
  end
end
