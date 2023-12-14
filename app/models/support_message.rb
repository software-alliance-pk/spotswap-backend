class SupportMessage < ApplicationRecord
  belongs_to :support_conversation
  has_one_attached :image, dependent: :destroy
  has_one_attached :file, dependent: :destroy
  belongs_to :sender, class_name: "User",foreign_key: :sender_id, optional: true

  validate :image_content_type, if: -> { image.attached? }
  validate :file_content_type, if: -> { file.attached? }

  after_create_commit { SupportMessageBroadcastJob.perform_later(self) }
  
  private

  def image_content_type
    unless image.content_type.in?(%w(image/png image/gif image/jpeg))
      errors.add(:image, 'must be a PNG, GIF, or JPEG image')
    end
  end

  def file_content_type
    unless file.content_type.in?(%w(application/pdf))
      errors.add(:file, 'must be a PDF file')
    end
  end
end
