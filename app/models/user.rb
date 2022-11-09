class User < ApplicationRecord
  has_one :car_detail, dependent: :destroy
  has_one :stripe_connect_account, dependent: :destroy
  has_secure_password
  has_many :supports, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :mobile_devices, dependent: :destroy
  has_many :card_details, dependent: :destroy
  has_many :quick_chats, dependent: :destroy
  has_many :blocked_user_details, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_one_attached :image, dependent: :destroy
  has_many :parking_slots, dependent: :destroy
  has_one :swapper_host_connection, dependent: :destroy

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

  private

  def referral_code_generator
    self.referral_code = (self.name + "_" + SecureRandom.hex(2)).delete(' ')
  end

end
