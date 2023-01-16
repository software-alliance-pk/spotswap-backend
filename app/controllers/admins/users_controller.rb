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
	end

  def view_profile
    @user = User.find_by(id: params[:id])
    @histories = @user.other_histories
    render partial: 'view_profile', locals:{user: @user, histories: @histories}
  end

  def export_csv
    @users = User.all
    respond_to do |format|
      format.csv { send_data @users.to_csv, filename: "users-#{Date.today}.csv" }
    end
  end

  def send_money_popup
    @user = User.find_by(id: params[:id])
    render partial: 'send_money_popup', locals:{user: @user, admin: Admin.admin.last}
  end

  def send_money

  end

  def send_money_confirmed
    @is_amount_transfer = false
    if params[:revenue][:user_id].present? && params[:revenue][:admin_id].present? && params[:revenue][:amount].present?
      user = User.find_by(id: params[:revenue][:user_id])
      admin = Admin.find_by(id: params[:revenue][:admin_id])
      amount = params[:revenue][:amount].to_i
      if admin.revenue.amount >= amount
        @transfer_response = StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account(amount, user.stripe_connect_account.account_id)
        update_revenue(amount, admin)
        @is_amount_transfer = true
      else
        flash[:alert] = "You have Insufficient Balance in your Revenue."
      end
    end
  end

  def disable_user_popup
    @user = User.find_by(id: params[:id])
  end

  def confirm_yes_popup
    @user = User.find_by(id: params[:id])
    @user.destroy
    render partial: 'confirm_yes_popup'
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
