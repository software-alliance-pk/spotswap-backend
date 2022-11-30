class UserStatusChannel < ApplicationCable::Channel

  def subscribed
    stream_from "user_status_channel"
    if current_user
      ActionCable.server.broadcast "user_status_channel", { user: current_user.id, online: :true }
      current_user.update!(is_online: true)
    end
  end

  def unsubscribed
    if current_user
      ActionCable.server.broadcast "user_status_channel", { user: current_user.id, online: :false }
      current_user.update!(is_online: false)
    end
  end 
end
