class Admins::UsersController < ApplicationController
	before_action :authenticate_admin!
  require 'csv'

	def index
    if params[:search_key].present?
			@users = User.where('name ILIKE :search_key OR email ILIKE :search_key 
      OR contact ILIKE :search_key', search_key: "%#{params[:search_key]}%")
      .paginate(page: params[:page]).order(created_at: :desc)
			@search_key = params[:search_key]
		else
      @users = User.all.paginate(page: params[:page]).order(created_at: :desc)
    end
    @notifications = Notification.where(is_clear: false).order(created_at: :desc)
	end

  def show_notification
    @notification = Notification.find_by(id: params[:id])
    @notification.update(is_clear: true)
    render partial: 'shared/notification_modal', locals:{notification: @notification}
  end

  def view_profile
    @user = User.find_by(id: params[:id])
    @histories = @user.other_histories
    render partial: 'view_profile', locals:{user: @user, histories: @histories}
  end

  def export_csv
    @start_date = Date.strptime(params[:daterange].split.first, "%m/%d/%Y")
    @end_date = Date.strptime(params[:daterange].split.third, "%m/%d/%Y")
    @users = User.where(is_disabled: false).where('Date(created_at) BETWEEN ? AND ?', @start_date, @end_date)
    respond_to do |format|
      format.csv { send_data @users.to_csv, filename: "users-#{Date.today}.csv" }
    end
  end

  def send_money_popup
    @user = User.find_by(id: params[:id])
    render partial: 'send_money_popup', locals:{user: @user, admin: Admin.admin.last}
  end

  def approve_user
    user = User.find_by(id: params[:id])
    history = user.send_money_histories.last
    if history.present? && history.is_approved == false
      admin = Admin.find_by(id: history.admin_id)
      amount = history.amount.to_i
      @transfer_response = StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account(amount*100, user.stripe_connect_account.account_id)
      update_revenue(amount, admin)
      history.update(is_approved: true)
      render partial: 'approve_user_success'
    end
  end

  def disapprove_user_popup
    @user = User.find_by(id: params[:id])
    render partial: 'disapprove_user_popup', locals:{user: @user, admin: Admin.admin.last}
  end

  def confirm_disapprove_popup
    @user = User.find_by(id: params[:id])
    render partial: 'confirm_disapprove_popup', locals:{user: @user, admin: Admin.admin.last}
  end

  def send_money
  end

  def send_money_confirmed
    @is_amount_transfer = false
    if params[:revenue][:user_id].present? && params[:revenue][:admin_id].present? && params[:revenue][:amount].present?
      user = User.find_by(id: params[:revenue][:user_id])
      admin = Admin.find_by(id: params[:revenue][:admin_id])
      amount = params[:revenue][:amount].to_i
      unless user.stripe_connect_account.present?
        @error_message = "User has not any Stripe Connect Account." and return
      end

      if admin.revenue.amount >= amount
        user.send_money_histories.build(admin_id: params[:revenue][:admin_id], amount: params[:revenue][:amount]).save!
        user.update(amount_transfer: params[:revenue][:amount], transfer_from: "Stripe Connect")
        @is_amount_transfer = true
      else
        @error_message = "You have Insufficient Balance in your Revenue."
      end
    end
  end

  def disable_user_popup
    @user = User.find_by(id: params[:id])
  end

  def confirm_yes_popup
    @user = User.find_by(id: params[:id])
    @user.update(is_disabled: true)
    @user.update(status: 'disabled')
    render partial: 'confirm_yes_popup'
  end

  def enable_user
    @user = User.find_by(id: params[:id])
    if @user.status!='active'
      @user.update(is_disabled: false)
      @user.update(status: 'active')
      render partial: 'enable_popup'
    end
  end

  def get_host_details
    @history = OtherHistory.find_by(id: params[:id])
    @host = User.find_by(id: @history.host_id)
    render partial: 'view_host_details', locals:{history: @history, host: @host}
  end

	private
  
  def authenticate_admin!
    if admin_signed_in?
      super
    else
      redirect_to new_admin_session_path, :notice => 'You need to sign in or sign up before continuing.'
    end
	end

  def update_revenue(amount, admin)
    amount = admin&.revenue&.amount - amount
    admin.revenue.update(amount: amount) if amount.present?
  end
end
