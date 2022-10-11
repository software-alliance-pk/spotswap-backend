class SupportMessage < ApplicationRecord
  belongs_to :user
  belongs_to :support_conversation
end
