  class Admins::SupportsController < ApplicationController
  before_action :authenticate_admin!
  include SupportsHelper
  require 'open-uri'

	def index
    if params[:search_key].present?
      @supports = Support.joins(:user).where('users.name ILIKE :search_key', search_key: "%#{params[:search_key]}%").all.order(created_at: :desc)
			@search_key = params[:search_key]
		else
      @supports = Support.all.order(created_at: :desc)
    end
    @last_support = @supports.first
    @notifications = Notification.where(is_clear: false).order(created_at: :desc)
    render 'index'
	end

  def admin_send_message
    conversation = current_admin.support_conversations.find_by(id: params[:id]) || Admin.admin&.first&.support_conversations&.find_by(id: params[:id])
    if conversation.present?
       @message = conversation.support_messages.new(sender_id: current_admin.id, body: params[:message], image: params[:image], file: params[:file])
       if @message.save
          data = {}
          data["id"] = @message.id
          data["support_conversation_id"] = @message.support_conversation_id
          data["body"] = @message.body
          data["user_id"] = @message.sender_id
          data["sender_id"] = @message.support_conversation.sender.id
          data["recipient_id"] =  @message.support_conversation.recipient.id
          data["created_at"] = @message.created_at.strftime("%H:%M")
          data["updated_at"] = @message.updated_at
          data["image"] = @message&.image&.url
          data["file"] = @message&.file&.url
          ActionCable.server.broadcast "support_conversations_#{@message.support_conversation_id}", { title: 'chat', body: data.as_json }
         @conversation =  conversation.support_messages.last
       end
    end
  end

  def get_specific_chat
    @last_support = Support.find_by(id: params["id"])
    @last_support&.support_conversation&.support_messages.update(read_status: true)
    @supports = Support.all.order(created_at: :desc)
    @notifications = Notification.where(is_clear: false).order(created_at: :desc)
    render 'index'
  end

  def update_ticket_status
    @support = Support.find_by(id: params[:support_id])
    unless @support.present?
      redirect_back(fallback_location: root_path) and return
    end
    if params[:status] == "pending"
      @support.update(status: "pending")
      flash[:success_alert] = "Support Ticket Status has been updated to Pending."
    elsif params[:status] == "completed"
      @support.update(status: "completed")
      flash[:success_alert] = "Support Ticket Status has been updated to Completed."
    end
    redirect_to get_specific_chat_admins_support_path(id: params[:support_id])
  end

  def download
    @message = SupportMessage.find_by(id: params[:id])  
    if params[:type] == "file" && @message.file.attached? && @message.file.present?
      attachment = @message.file
    elsif params[:type] == "image" && @message.image.attached? && @message.image.present?
      attachment = @message.image
    end
    if attachment.present?
      download = attachment.download
      content_type = attachment.content_type
      # Define a mapping between content types and file extensions
      content_type_to_extension = {
        'application/pdf' => 'pdf',
        'image/jpeg' => 'jpeg',
        'image/jpg' => 'jpg',
        'image/png' => 'png',
        # Add more mappings as needed
      }
      # Set the filename based on content type
      filename = "#{Time.now.to_i}_spot_swap.#{content_type_to_extension[content_type]}"
      send_data download, disposition: 'attachment', filename: filename, type: content_type
    else
      flash[:error] = 'File or image not found'
      redirect_to root_path
    end
  end

  private
  
  def authenticate_admin!
    if admin_signed_in?
      super
    else
      redirect_to new_admin_session_path, :notice => 'You need to sign in or sign up before continuing.'
    end
	end
end

