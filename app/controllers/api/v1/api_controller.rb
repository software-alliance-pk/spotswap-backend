class Api::V1::ApiController < ActionController::API
  def not_found
    render json: { error: 'No route matches with given address' }
  end

  def generate_payload_for_online(conversation_id, sender_id, sender_online_status, receipient_id, receipient_online_status)
    data = {
      conversation_id: conversation_id,
      sender_id: sender_id,
      sender_online_status: sender_online_status,
      receipient_id: receipient_id,
      receipient_online_status: receipient_online_status
    }
    ActionCable.server.broadcast("user_status_#{@current_user.id}", {
      title: 'Online Status',
      body: data
    })
  end

  def render_error_messages(object)
    render json: {
      error: object.errors.messages.map { |msg, desc|
        msg.to_s.capitalize.to_s.gsub("_"," ") + ' ' + desc[0] }.join(', ')
    }, status: :unprocessable_entity
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find_by_id(@decoded[:user_id]) || User.find_by_email(@decoded[:email])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end
end