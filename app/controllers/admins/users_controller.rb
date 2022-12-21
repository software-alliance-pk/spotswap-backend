class Admins::UsersController < ApplicationController
	before_action :authenticate_admin!

	def index
    if params[:search_key].present?
			@users = User.custom_search(params[:search_key]).paginate(page: params[:page]).order(created_at: :desc)
			@search_key = params[:search_key]
		else
      @users = User.all.paginate(page: params[:page]).order(created_at: :desc)
    end
	end

  def view_profile
    @user = User.find_by(id: params[:id])
    render partial: 'view_profile', locals:{user: @user}
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
