class Api::V1::SupportsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :support_params, only: [:create_ticket]
  before_action :find_support_conversation, only: [:create_message, :get_all_support_messages]
  before_action :find_user, only: [:create_message]

  def create_ticket
    @ticket = @current_user.supports.build(support_params.merge(ticket_number: generate_ticket_number.upcase))
    if @ticket.save
      @support_conversation = @ticket.build_support_conversation(sender_id: @ticket.user_id, recipient_id: Admin.admin.first.id)
      if @support_conversation.save
        @support_message = @support_conversation.support_messages.build(sender_id: @ticket.user_id, user_id: Admin.admin.first.id, body: @ticket.description, image: support_params[:image])
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

  def get_all_support_messages
	  @support_messages = @support_conversation.support_messages.order(created_at: :desc)
  end

  def create_message
    @support_message = SupportMessage.new(message_params)
    @support_message.user_id = Admin.admin.first.id
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

  def find_support_conversation
		if params[:support_conversation_id].present?
			@support_conversation = SupportConversation.find_by(id: params[:support_conversation_id])
			render json: {error: "Support Conversation with this id is not present."}, status: :unprocessable_entity unless @support_conversation.present?
		else
			render json: {error: "Support Conversation id is missing."}, status: :unprocessable_entity
		end
	end

  def find_user
		if params[:sender_id].present?
			@user = User.find_by(id: params[:sender_id])
			render json: {error: "User with this id is not present."}, status: :unprocessable_entity unless @user.present?
		else
			render json: {error: "Sender id is missing."}, status: :unprocessable_entity
		end
	end

  def support_params
    params.permit(:status, :description, :image)
  end

  def message_params
    params.permit(:body, :sender_id, :support_conversation_id, :image)
  end
end