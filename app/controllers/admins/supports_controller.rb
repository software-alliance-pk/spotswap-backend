class Admins::SupportsController < ApplicationController
  before_action :authenticate_admin!
  include SupportsHelper

	def index
    @supports = Support.pending.order(created_at: :desc)
    @last_support = @supports.first
	end

  def admin_send_message
    byebug
    conversation = current_admin.support_conversations.find_by(id: params[:id])
    if conversation.present?
       @message = conversation.support_messages.new(user_id: current_admin.id, body: params[:message],image: params[:image],file: params[:file])
       if @message.save
          data = {}
          data["id"] = @message.id
          data["support_conversation_id"] = @message.support_conversation_id
          data["body"] = @message.body
          data["user_id"] = @message.sender_id
          data["sender_id"] = @message.support_conversation.sender.id
          data["recipient_id"] =  @message.support_conversation.recipient.id
          data["created_at"] = @message.created_at
          data["updated_at"] = @message.updated_at
          data["image"] = @message&.image&.url
          ActionCable.server.broadcast "support_conversations_#{@message.support_conversation_id}", { title: 'dsadasdas', body: data.as_json }
         @conversation =  conversation.support_messages.last
       end
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
