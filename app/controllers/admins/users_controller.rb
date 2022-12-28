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
    render partial: 'view_profile', locals:{user: @user}
  end

  def export_csv
    @users = User.all
    respond_to do |format|
      format.csv { send_data @users.to_csv, filename: "users-#{Date.today}.csv" }
    end
  end

  def send_money_popup
    @user = User.find_by(id: params[:id])
    render partial: 'send_money_popup', locals:{user: @user}
  end

  def disable_user_popup
    @user = User.find_by(id: params[:id])
  end

  def confirm_yes_popup
    @user = User.find_by(id: params[:id])
    @user.destroy
    render partial: 'confirm_yes_popup'
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
