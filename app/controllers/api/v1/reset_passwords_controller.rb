class Api::V1::ResetPasswordsController < Api::V1::ApiController
  before_action :find_user

  def send_otp 
    @otp = 6.times.map{rand(10)}.join
    begin
      UserMailer.send_email(@user, @otp).deliver_now
    rescue  => e
      return render json: { message: e.error_message}, status: 422
    end
    @user.update(otp: @otp, otp_expiry:(Time.current + 2.minutes))
  end

  def resend_otp
    @otp = 6.times.map{rand(10)}.join
    begin
      UserMailer.send_email(@user, @otp).deliver_now
    rescue  => e
      return render json: { error: e.error_message}, status: 422
    end
    @user.update(otp: @otp, otp_expiry:(Time.current + 2.minutes))  
  end
  
  def verify_otp
    return render json: {error: "OTP parameter is missing"}, status: :unprocessable_entity unless params[:otp].present? 
    if @user.otp == params[:otp].to_i && @user.otp_expiry >= Time.current
      render json: { message: "otp is verified" }, status: :ok
    elsif @user.otp_expiry < Time.current
      render json: { error: "otp has been expired."}, status: :unprocessable_entity
    else
      render json: { error: "otp is not valid"}, status: :unprocessable_entity
    end
  end

  def reset_password
    return render json: {error: "Password parameter is missing"}, status: :unprocessable_entity unless params[:password].present? 
    return render json: {error: "Confirm password parameter is missing"}, status: :unprocessable_entity unless params[:password_confirmation].present? 
    return render json: {error: "Password does not match"}, status: :unprocessable_entity unless params[:password] == params[:password_confirmation]
    if @user.update(password: params[:password])
      render json: { message: "Password updated successfully"}, status: :ok
    else
      render json: { error: @user.errors.full_messages }, status: 422 
    end
  end

  private
  
  def find_user
    return render json: {error: "Email parameter is missing "}, status: :unprocessable_entity unless params[:email].present?
    @user = User.find_by(email: params[:email])
    return render json: {error: "User not found against given email"},status: :unprocessable_entity unless @user.present?
  end
end