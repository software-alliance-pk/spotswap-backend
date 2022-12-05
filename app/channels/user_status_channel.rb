class UserStatusChannel < ApplicationCable::Channel

  def subscribed
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts params
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    if params[:user_id].present?
      puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      puts params
      puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      stream_from "user_#{(params[:user_id])}"
    else
      puts "User Id is missing."
    end
  end

  def unsubscribed
    stop_all_streams
  end 
end
