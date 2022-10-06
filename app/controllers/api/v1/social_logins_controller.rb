class Api::V1::SocialLoginsController < Api::V1::ApiController
  def social_login
    return render json: {message: 'Please provide correct provider e.g google'},
     status: :unprocessable_entity unless params['provider'].present?
    return render json: {message: 'Please provide social login token'},
     status: :unprocessable_entity unless params['token'].present?
    response = SocialLoginService.new(params['provider'], params['token']).social_login
    if  response[0]&.class&.to_s == "User"
      @user = response[0]
      @token = response[1]
    else
      render json: { message: "Token has been Expired" }, status: :unprocessable_entity
    end
  end
end
