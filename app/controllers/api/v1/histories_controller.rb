class Api::V1::HistoriesController < Api::V1::ApiController
  before_action :authorize_request

  def get_user_other_payment_histories
    @payment_histories = @current_user.other_histories.order(created_at: :desc)
  end
end