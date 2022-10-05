class Api::V1::ResetPasswordsController < Api::V1::ApiController
  before_action :find_user

  def forgot_password
    return render json:{
      message: "User not found against given number"
    },status: 404 unless @user.present?
    
    otp = 4.times.map{rand(10)}.join
    begin 
      ActiveRecord::Base.transaction do
        TwilioService.new(@user.phone_number, otp).send_otp
      end
    rescue  => e
      return render json: { message: e.error_message}, status: 422
    end
    
    @user.update(otp: otp, otp_expiry:(Time.current + 2.minutes))  
    render json: { 
      message: "Your forgot password otp sent successfully"
    } 
  end
  
  # def verify_otp
  #   return render json:{ 
  #     message: "User not found against given number"
  #   },status: 404 unless @user.present?
    
  #   if @user.otp == params[:otp].to_i && @user.otp_expiry >= Time.current && params[:otp].present?
  #     render json: { message: "Otp verified" }
  #   else
  #     render json: { message: "otp not valid"}, status: 406
  #   end
  # end

  # def reset_password
  #   return render json:{ 
  #     message: "User not found against given number"
  #   },status: 404 unless @user.present?
    
  #   if @user.update(password_params)
  #     render json: { message: "Password updated successfully"}
  #   else
  #     render json: { message: @user.errors.full_messages }, status: 422 
  #   end
  # end

  private
  
  # def password_params
  #   params.require(:user).permit(:password, :password_confirmation)
  # end

  def find_user
    @user = User.find_by(phone_number: params[:phone_number])
  end
end