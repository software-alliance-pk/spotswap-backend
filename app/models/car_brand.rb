class CarBrand < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :custom_search,
                  against: [:title],
                  using: {
                    trigram: {
                      threshold: 0.3,
                      word_similarity: true
                    }
                  }

  has_many :car_models, dependent: :destroy
  has_one_attached :image, dependent: :destroy
  
  validates :title, presence: true
end
