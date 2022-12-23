module SupportsHelper
  def last_message (support)
    support&.support_conversation&.support_messages&.last&.body
  end

  def last_seen (support)
    support.support_conversation&.support_messages&.last&.created_at
  end

  def unread_count (support)
    support.support_conversation&.support_messages&.where(read_status: false)&.count
  end
end
