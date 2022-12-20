class Api::V1::PayPalController < Api::V1::ApiController

  def pay_pal_confirm
    payer_id = params["PayerID"]
    paymentId = params["paymentId"]
    PayPalPaymentService.new.transfer_amount(paymentId,payer_id)
  end
  def pay_pal_cancel
    debugger
  end
end