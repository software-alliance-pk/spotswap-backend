class Api::V1::MessagesController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_conversation, only: [:create_message, :get_all_messages, :delete_conversation]
  before_action :find_user_type_for_conversation, only: [:create_conversation, :get_all_messages]

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
    #return render json: {error: "User can't create conversation with himself."}, status: :unprocessable_entity if @current_user.id == params[:recepient_id]  
    @conversation = Conversation.where(user_id: @current_user.id, recepient_id: params[:recepient_id]).or(Conversation.where(user_id: params[:recepient_id], recepient_id: @current_user.id))
    unless @conversation.empty?
      @conversation = @conversation.first
      generate_payload_for_online(@conversation.id, @conversation.sender.id, @conversation.sender.is_online, @conversation.recepient.id, @conversation.recepient.is_online)
    else
      @conversation = Conversation.new(conversation_params.merge(user_id: @current_user.id))
      if @conversation.save
        @conversation
        generate_payload_for_online(@conversation.id, @conversation.sender.id, @conversation.sender.is_online, @conversation.recepient.id, @conversation.recepient.is_online)
      else
        render_error_messages(@conversation)
      end
    end 
  end

  def get_all_messages
	  @messages = @conversation.messages.all.order(created_at: :desc)
  end

  def get_all_conversations
	  @conversations = Conversation.where(user_id: @current_user.id).or(Conversation.where(recepient_id: @current_user.id)).order(created_at: :desc)
  end

  def delete_conversation
	  @conversation.destroy
    render json: { message: "Conversation has been removed successfully."}, status: :ok
  end

  def block_or_unblock_user
    return render json: {error: "user id is missing."}, status: :unprocessable_entity unless params[:user_id].present?
    @conversation = Conversation.where(recepient_id: @current_user.id, user_id: params[:user_id]).or(Conversation.where(recepient_id: params[:user_id], user_id: @current_user.id))
    is_user_blocked = BlockedUserDetail.find_by(blocked_user_id: params[:user_id], user_id: @current_user.id)
    if is_user_blocked.present?
      @conversation.update(is_blocked: false)
      is_user_blocked.destroy
      return render json: { message: "Conversation is unblocked."}, status: :ok
    else
      if @conversation.present?
        @conversation.update(is_blocked: true)
        @block_user_detail = BlockedUserDetail.new(blocked_user_id: params[:user_id], user_id: @current_user.id)
        if @block_user_detail.save
          return render json: { message: "Conversation is blocked."}, status: :ok
        else
          render_error_messages(@block_user_detail)
        end
      else
        render json: { error: "You have not any conversation with this user id."}, status: :unprocessable_entity
      end
    end
  end

  private

  def message_params
    params.permit(:body, :conversation_id, :image)
  end

  def conversation_params
    params.permit(:recepient_id)
  end


  def find_user_type_for_conversation
    @user_type = "Swapper" if @current_user.host_swapper_connection.present?
    @user_type = "Host" if @current_user.swapper_host_connection.present?
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