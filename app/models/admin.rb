class Admin < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :custom_search,
                  against: [:full_name, :email, :contact, :status],
                  # associated_against: {
                  #   car_detail: [:color],
                  #   user_car_brand: [:title],
                  #   user_car_model: [:title]}
                  using: {
                    trigram: {
                      threshold: 0.3,
                      word_similarity: true
                    }
                  }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum category: [:admin, :sub_admin]
  enum status: [:active, :disabled]
  has_many :support_conversations, dependent: :destroy, foreign_key: :recipient_id
  has_one_attached :image, dependent: :destroy
  self.per_page = 1

  validates :full_name, :category, :contact, :location , presence: true
  validates :contact, uniqueness: true
end
