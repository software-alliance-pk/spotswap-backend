class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum category: [:admin, :sub_admin]
  enum status: [:active, :disabled]
  has_many :support_conversations, dependent: :destroy, foreign_key: :recipient_id

  validates :full_name, :category, :contact, :location , presence: true
  validates :contact, uniqueness: true
end
