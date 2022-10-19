module SupportsHelper
  def last_message (user)
    user.supports.last&.support_conversation&.support_messages&.last&.body
  end

  def last_seen (user)
    user.supports.last&.support_conversation&.support_messages&.last&.created_at
  end

  def unread_count (user)
    user.supports.last&.support_conversation&.support_messages&.where(read_status: false)&.count
  end
end
