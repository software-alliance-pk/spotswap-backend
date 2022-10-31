class Api::V1::MessagesController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_conversation, only: [:create_message, :get_all_messages, :delete_conversation]
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

  def get_all_conversations
	  @conversations = Conversation.where(sender_id: @current_user.id)or(Conversation.where(recepient_id: @current_user.id)).order(created_at: :desc)
  end

  def delete_message
	  @message.destroy
    render json: { message: "message is removed successfully"}, status: :ok
  end

  def delete_conversation
	  @conversation.destroy
    render json: { message: "conversation is removed successfully"}, status: :ok
  end

  def block_user
    return render json: {error: "user id is missing."}, status: :unprocessable_entity unless params[:user_id].present?
    is_user_already_blocked = BlockedUserDetail.find_by(blocked_user_id: params[:user_id], user_id: @current_user.id)
    return render json: {error: "This user is already blocked by you."}, status: :unprocessable_entity if is_user_already_blocked.present?
    conversation = Conversation.find_by(recepient_id: @current_user.id, sender_id: params[:user_id])
    if conversation.present?
      conversation.update(is_blocked: true)
      @block_user_detail = BlockedUserDetail.new(blocked_user_id: params[:user_id], user_id: @current_user.id)
      if @block_user_detail.save
        @block_user_detail
      else
        render_error_messages(@block_user_detail)
      end
    else
      render json: { message: "You have not any conversation with this user id."}, status: :unprocessable_entity
    end
  end

  def unblock_user
    return render json: {error: "user id is missing."}, status: :unprocessable_entity unless params[:user_id].present?
    is_user_blocked = BlockedUserDetail.find_by(blocked_user_id: params[:user_id], user_id: @current_user.id)
    return render json: {error: "This user is not in your blocklist. please block this user first."}, status: :unprocessable_entity unless is_user_blocked.present?
    is_user_blocked.destroy
    return render json: { message: "User is unblocked."}, status: :ok
  end

  private

  def message_params
    params.permit(:id, :body, :read_status, :conversation_id)
  end

  def find_conversation
		if params[:conversation_id].present?
			@conversation = Conversation.find_by(id: params[:conversation_id])
			render json: {message: "Conversation with this id is not present."}, status: 200 unless @conversation.present?
		else
			render json: {message: "Conversation id is missing."}, status: :unprocessable_entity
		end
	end

  def find_message
    return render json: {error: "message id is missing."}, status: :unprocessable_entity unless params[:id].present?
    @message = Message.find_by(id: params[:id])
    return render json: {error: "message with this id is not present."}, status: :unprocessable_entity unless @message.present?
  end
end