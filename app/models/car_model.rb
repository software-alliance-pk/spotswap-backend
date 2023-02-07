class CarModel < ApplicationRecord
  require 'csv'
  belongs_to :car_brand
  has_one_attached :image, dependent: :destroy
  self.per_page = 10

  validates :title, :color, :length, :width, :height, :released, presence: true
  validates :title, uniqueness: true

  def self.to_csv
    attributes = %w{Model Color Length Width Height Released}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |model|
        csv << [
          model.title,
          model.color,
          model.length,
          model.width,
          model.height,
          model.released
        ]
      end
    end
  end

end
