class Api::V1::ResetPasswordsController < Api::V1::ApiController
  before_action :find_user

  def send_otp
    return render json:{
      message: "User not found against given email"
    },status: 404 unless @user.present?
    
    otp = 4.times.map{rand(10)}.join
    begin
      UserMailer.send_email(@user, otp).deliver_now
    rescue  => e
      return render json: { message: e.error_message}, status: 422
    end
    
    @user.update(otp: otp, otp_expiry:(Time.current + 2.minutes))  
    render json: { 
      message: "Your forgot password otp has been sent successfully."
    } 
  end

  def resend_otp
    return render json:{
      message: "User not found against given email"
    },status: 404 unless @user.present?
    
    otp = 4.times.map{rand(10)}.join
    begin
      UserMailer.send_email(@user, otp).deliver_now
    rescue  => e
      return render json: { message: e.error_message}, status: 422
    end
    
    @user.update(otp: otp, otp_expiry:(Time.current + 2.minutes))  
    render json: { 
      message: "otp has been resent successfully."
    } 
  end
  
  def verify_otp
    return render json:{ 
      message: "User not found against given email"
    },status: 404 unless @user.present?
    
    if @user.otp == params[:otp].to_i && @user.otp_expiry >= Time.current && params[:otp].present?
      render json: { message: "otp is verified" }
    else
      render json: { message: "otp is not valid"}, status: 406
    end
  end

  def reset_password
    return render json:{
      message: "User not found against given email"
    },status: 404 unless @user.present?
    
    if params[:password] == params[:password_confirmation]
      if @user.update(password: params[:password])
        render json: { message: "Password updated successfully"}
      else
        render json: { message: @user.errors.full_messages }, status: 422 
      end
    else
      render json: { message: "password and password confirmation should match."}
    end
  end

  private
  
  def find_user
    @user = User.find_by(email: params[:email])
  end
end