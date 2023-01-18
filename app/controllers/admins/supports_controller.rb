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
    @notifications = Notification.all
    render 'index'
	end

  def admin_send_message
    conversation = current_admin.support_conversations.find_by(id: params[:id])
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
          ActionCable.server.broadcast "support_conversations_#{@message.support_conversation_id}", { title: 'chat', body: data.as_json }
         @conversation =  conversation.support_messages.last
       end
    end
  end

  def get_specific_chat
    @last_support = Support.find_by(id: params["id"])
    @supports = Support.all.order(created_at: :desc)
    @notifications = Notification.all
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
    url = @message.image.url
    download = URI.open(@message.image.url)
    filename = url.to_s.split('/')[-1]
    send_data download.read, disposition: 'attachment', filename: filename
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
