class Api::V1::ApiController < ActionController::API
  def not_found
    render json: { error: 'No route matches with given address' }
  end

  def render_error_messages(object)
    render json: {
      message: object.errors.messages.map { |msg, desc|
        msg.to_s.capitalize.to_s.gsub("_"," ") + ' ' + desc[0] }.join(', ')
    }, status: :unprocessable_entity
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      puts @decoded
      puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      @current_user = User.find(@decoded[:user_id]) || User.find_by_email(@decoded[:email])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end