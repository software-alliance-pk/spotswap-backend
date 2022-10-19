class Api::V1::SupportsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :support_params, only: [:create_ticket]

  def create_ticket
    @ticket = @current_user.supports.new(support_params.merge(ticket_number: generate_ticket_number.upcase))
    if @ticket.save
      @support_conversation = @ticket.build_support_conversation(sender_id: @ticket.user_id, recipient_id: Admin.admin.first.id)
      if @support_conversation.save
        @support_message = @support_conversation.support_messages.build(user_id: @ticket.user_id, body: @ticket.description, image: support_params[:image])
        @support_message.save
      end
    else
      render_error_messages(@ticket)
    end
  end

  def get_tickets
    @pending_tickets = @current_user.supports.pending.order("created_at desc")
    @completed_tickets = @current_user.supports.completed.order("created_at desc")
  end

  def create_message
    @support_message = SupportMessage.new(message_params)
    if @support_message.save
      @support_message
    else
      render_error_messages(@support_message)
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

  def message_params
    params.permit(:body, :user_id, :support_conversation_id, :image)
  end
end