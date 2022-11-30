class CarModel < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :custom_search,
                  against: [:title],
                  using: {
                    trigram: {
                      threshold: 0.3,
                      word_similarity: true
                    }
                  }

  belongs_to :car_brand
  has_one_attached :image, dependent: :destroy
  self.per_page = 2

  validates :title, :color, :length, :width, :height, :released, presence: true
end
