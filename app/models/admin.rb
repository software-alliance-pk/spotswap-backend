class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum category: [:admin, :sub_admin]
  enum status: [:active, :disabled]
  has_many :support_conversations, dependent: :destroy, foreign_key: :recipient_id
  has_one :revenue, dependent: :destroy

  has_one_attached :image, dependent: :destroy
  self.per_page = 10

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  validates :full_name, :category, presence: true
end
