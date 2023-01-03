class Wallet < ApplicationRecord
  attr_accessor :wallet_amount
  belongs_to :user
  enum payment_type: [:credit_card, :paypal, :wallet]

  after_create :create_wallet_history

  def create_wallet_history
    StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account(wallet_amount.to_i, self.user.stripe_connect_account.account_id)
    self.user.wallet_histories.create(transaction_type: "credited", top_up_description: "bank_transfer", amount: wallet_amount, title: "Top Up")
  end
end
