class Api::V1::MessagesController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_conversation, only: [:create_message, :get_all_messages, :delete_conversation]

  def create_message
    @message = @current_user.messages.build(message_params)
    if @message.save
      @message
    else
      render_error_messages(@message)
    end
  end

  def create_conversation
    return render json: {error: "recepient id is missing."}, status: :unprocessable_entity unless params[:recepient_id].present?
    return render json: {error: "User with entered recepient id does not exist."}, status: :unprocessable_entity unless User.find_by_id(params[:recepient_id]).present?
    @conversation = Conversation.new(conversation_params)
    @conversation.sender_id = @current_user.id
    if @conversation.save
      @conversation
    else
      render_error_messages(@conversation)
    end
  end

  def get_all_messages
	  @messages = @conversation.messages.all.order(created_at: :desc)
  end

  def get_all_conversations
	  @conversations = Conversation.where(sender_id: @current_user.id).or(Conversation.where(recepient_id: @current_user.id)).order(created_at: :desc)
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
      render json: { error: "You have not any conversation with this user id."}, status: :unprocessable_entity
    end
  end

  def unblock_user
    return render json: {error: "user id is missing."}, status: :unprocessable_entity unless params[:user_id].present?
    is_user_blocked = BlockedUserDetail.find_by(blocked_user_id: params[:user_id], user_id: @current_user.id)
    return render json: {error: "This user is not in your blocklist. please block this user first."}, status: :unprocessable_entity unless is_user_blocked.present?
    conversation = Conversation.find_by(recepient_id: @current_user.id, sender_id: params[:user_id])
    conversation.update(is_blocked: false)
    is_user_blocked.destroy
    return render json: { message: "User is unblocked."}, status: :ok
  end

  private

  def message_params
    params.permit(:body, :conversation_id, :image)
  end

  def conversation_params
    params.permit(:recepient_id)
  end

  def find_conversation
		if params[:conversation_id].present?
			@conversation = Conversation.find_by(id: params[:conversation_id])
			render json: {error: "Conversation with this id is not present."}, status: :unprocessable_entity unless @conversation.present?
		else
			render json: {error: "Conversation id is missing."}, status: :unprocessable_entity
		end
	end
end