class Api::V1::MessagesController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_conversation, only: [:create_message, :get_all_messages]
  before_action :find_message, only: [:delete_message]

  def create_message
    @message = @current_user.messages.build(message_params)
    if @message.save
      @message
    else
      render_error_messages(@message)
    end
  end

  def get_all_messages
	  @messages = @conversation.messages.all.order(created_at: :desc)
  end

  def delete_message
	  @message.destroy
    render json: { message: "message is removed successfully"}, status: :ok
  end

  private

  def message_params
    params.permit(:id, :body, :read_status, :conversation_id)
  end

  def find_conversation
		if params[:conversation_id].present?
			@conversation = Conversation.find_by(id: params[:conversation_id])
			render json: {message: "Conversation with this id is not present.."}, status: 200 unless @conversation.present?
		else
			render json: {message: "Conversation id is missing"}, status: 200
		end
	end

  def find_message
    return render json: {error: "message id is missing."}, status: :unprocessable_entity unless params[:id].present?
    @message = Message.find_by(id: params[:id])
    return render json: {error: "message with this id is not present."}, status: :unprocessable_entity unless @message.present?
  end
end