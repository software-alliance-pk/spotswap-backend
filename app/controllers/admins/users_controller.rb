class Admins::UsersController < ApplicationController
	before_action :authenticate_admin!

	def index
    @users = User.all.order(created_at: :desc)
	end

  def view_profile
    @user = User.find_by(id: params[:id])
  end

  def send_money_popup
    @user = User.find_by(id: params[:id])
  end

  def disable_user_popup
    @user = User.find_by(id: params[:id])
  end

  def confirm_yes_popup
    @user = User.find_by(id: params[:id])
    @user.destroy
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
