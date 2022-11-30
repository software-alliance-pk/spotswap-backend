class UserStatusChannel < ApplicationCable::Channel

  def subscribed
    if params[:user_id].present?
      stream_from "user_#{(params[:user_id])}"
    else
      puts "User Id is missing."
    end
  end

  def unsubscribed
    stop_all_streams
  end 
end
