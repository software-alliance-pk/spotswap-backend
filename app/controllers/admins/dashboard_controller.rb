class Admins::DashboardController < ApplicationController
	before_action :authenticate_admin!

	def index
    @users = User.all.order(created_at: :desc)
    @cars = CarDetail.all
	end

  def sub_admins_index
    @sub_admins = Admin.where(category: "sub_admin").order(created_at: :desc)
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
