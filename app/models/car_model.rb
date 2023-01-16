class CarModel < ApplicationRecord
  require 'csv'
  belongs_to :car_brand
  has_one_attached :image, dependent: :destroy
  self.per_page = 10

  validates :title, :color, :length, :width, :height, :released, presence: true

  def self.to_csv
    attributes = %w{title color length width height released}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |model|
        csv << attributes.map{ |attr| model.send(attr) }
      end
    end
  end

end
