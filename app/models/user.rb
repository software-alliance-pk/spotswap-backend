class User < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :custom_search,
                  against: [:name, :email, :contact, :status],
                  # associated_against: {
                  #   car_detail: [:color],
                  #   user_car_brand: [:title],
                  #   user_car_model: [:title]}
                  using: {
                    tsearch: {dictionary: "english"}
                  }

  attr_accessor :referrer_code, :referrer_id

  has_one :car_detail, dependent: :destroy
  has_one :stripe_connect_account, dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_secure_password
  has_many :supports, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :mobile_device, dependent: :destroy
  has_many :card_details, dependent: :destroy
  #has_one :default_payment, class_name: :default_payment, through: :card_details
  has_one :default_payment, dependent: :destroy
  has_many :quick_chats, dependent: :destroy
  has_many :blocked_user_details, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_one_attached :image, dependent: :destroy
  has_one :parking_slot, dependent: :destroy
  has_one :swapper_host_connection, dependent: :destroy, class_name: :SwapperHostConnection, foreign_key: :user_id
  has_one :host_swapper_connection, dependent: :destroy, class_name: :SwapperHostConnection, foreign_key: :host_id
  has_many :user_referral_code_records, dependent: :destroy
  has_many :histories, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
  validates :contact, presence: true, uniqueness: true

  enum status: [:active, :disabled]

  acts_as_mappable :default_units => :kms,
  :default_formula => :sphere,
  :distance_field_name => :distance,
  :lat_column_name => :latitude,
  :lng_column_name => :longitude

  before_save :referral_code_generator
  after_commit :user_referral_code_record_generator

  self.per_page = 10

  private

  def referral_code_generator
    self.referral_code = (self.name + "_" + SecureRandom.hex(2)).delete(' ')
  end

  def user_referral_code_record_generator
    if self.referrer_code.present? && self.referrer_id.present?
      unless self.user_referral_code_records.where(referrer_code: self.referrer_code, referrer_id: self.referrer_id).present?
       UserReferralCodeRecord.create(user_id: self.id, user_code: self.referral_code, referrer_code: self.referrer_code, referrer_id: self.referrer_id)
      end
    end
  end

end
