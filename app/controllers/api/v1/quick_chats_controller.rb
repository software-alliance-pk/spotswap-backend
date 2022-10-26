class Api::V1::QuickChatsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_specific_quick_chat, only: [:delete_quick_chat, :update_quick_chat]

  def get_all_quick_chat
    @quick_chat = @current_user.quick_chats.order(created_at: :desc)
  end

  def create_quick_chat
    @quick_chat = @current_user.quick_chats.new(quick_chat_params)
    if  @quick_chat.save
      @quick_chat
    else
      render_error_messages(@quick_chat)
    end
  end

  def update_quick_chat
    if @quick_chat.update(message: params[:message])
      @quick_chat
    else
      render_error_messages(@quick_chat)
    end
  end

  def delete_quick_chat
      @quick_chat.destroy
      render json: { message: "Quick chat is removed successfully"}, status: :ok
  end

  private

  def quick_chat_params
    params.permit(:message)
  end

  def find_specific_quick_chat
    return render json: {error: "Quick chat id parameter is missing"},status: :unprocessable_entity
    @quick_chat = @current_user.quick_chats.find_by(id: params[:id])
    render json: {error: "No such quick chat is present"}, status: :unprocessable_entity unless @quick_chat.present?
  end
end