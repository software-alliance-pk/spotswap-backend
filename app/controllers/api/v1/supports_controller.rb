class Api::V1::SupportsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :support_params, only: [:create_ticket]

  def create_ticket
    @ticket = @current_user.supports.new(support_params.merge(ticket_number: generate_ticket_number.upcase))
    if @ticket.save
      @ticket
    else
      render_error_messages(@ticket)
    end
  end

  def get_tickets
    @tickets = @current_user.supports.order("created_at desc")
    if @tickets
      @tickets
    else
      render_error_messages(@tickets)
    end
  end

  def generate_ticket_number
    @ticket_number = loop do
      random_token = SecureRandom.urlsafe_base64(6, false)
      break random_token unless Support.exists?(ticket_number: random_token)
    end
  end

  private
  def support_params
    params.permit(:user_id, :ticket_number, :status, :description, :image, :name)
  end
end