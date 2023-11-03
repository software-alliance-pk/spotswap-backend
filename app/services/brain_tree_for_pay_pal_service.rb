class BrainTreeForPayPalService
  def initialize
    @gateway = Braintree::Gateway.new(
      :environment => :sandbox,
      :merchant_id => "fdsw52dzc4kps6dd",
      :public_key => "ny239b8bxb4rcw87",
      :private_key => "0c727e07beaf7ddd2696bb8b1e6116d2",
      )
  end

  def find_the_customer_at_pay_pal
    customer = @gateway.customer.find("887572767")
  end

  def create_payment_method_for_customer
    result = @gateway.payment_method.create(
      :customer_id => "887572767",
      :payment_method_nonce => "fake-valid-no-billing-address-nonce"
    )
    #it is used only for testing
    #fake-valid-no-billing-address-nonce
  end

  def create_customer_at_pay_pal
    result = @gateway.customer.create(
      :first_name => "GIN",
      :last_name => "LONG",
      :company => "SpotSwap",
      :email => "gin@example.com",
      :phone => "312.555.1234",
      :fax => "614.555.5678",
      :website => "www.example.com"
    )
    if result.success?
      puts result.customer.id
    else
      p result.errors
    end
  end
end