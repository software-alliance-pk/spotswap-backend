class Admins::DashboardController < ApplicationController
	before_action :authenticate_admin!
  before_action :sub_admin_params, only: [:create_sub_admin]
  before_action :find_sub_admin, only: [:delete_sub_admin, :enable_sub_admin]

	def index
    if params[:type]=="view_all"
      @users = User.all.order(created_at: :desc)
      @type = "view_all"
    else
      @users = User.all.order(created_at: :desc).limit(10)
    end
    @cars = CarDetail.all
    @revenue = Revenue.first.amount
    @csv_download_count = Setting.first.csv_download_count
    @notifications = Notification.where(is_clear: false).order(created_at: :desc)
	end

  def sub_admins_index
    if params[:search_key].present?
      @sub_admins = Admin.where('full_name ILIKE :search_key OR email ILIKE :search_key 
      OR contact ILIKE :search_key OR location ILIKE :search_key OR status ILIKE :search_key', search_key: "%#{params[:search_key]}%")
      .where(category: "sub_admin").paginate(:per_page => params[:per_page], page: params[:page]).order(created_at: :desc)
      @search_key = params[:search_key]
		else
      @sub_admins = Admin.where(category: "sub_admin").paginate(:per_page => params[:per_page], page: params[:page]).order(created_at: :desc)
    end
    @notifications = Notification.where(is_clear: false).order(created_at: :desc)
  end

  def create_sub_admin
    @sub_admin = Admin.new(sub_admin_params.except(:f_name, :l_name, :country_code))
    @sub_admin.full_name = sub_admin_params[:f_name] + ' ' + sub_admin_params[:l_name]
    @sub_admin.category = "sub_admin"
    @sub_admin.status = 'active'
    if @sub_admin.save
      redirect_to sub_admins_index_admins_dashboard_index_path
      flash[:success_alert] = "Sub Admin has been created successfully."
    else
      redirect_to sub_admins_index_admins_dashboard_index_path
      flash[:success_alert] = @sub_admin.errors.full_messages.to_sentence
    end
  end

  def delete_sub_admin
    if @sub_admin.status!="disabled"
      if @sub_admin.update(status: "disabled")
        redirect_to sub_admins_index_admins_dashboard_index_path
        flash[:notice] = "Sub Admin has been disabled successfully."
      else
        redirect_to sub_admins_index_admins_dashboard_index_path
        flash[:notice] = @sub_admin.errors.full_messages.to_sentence
      end
    else
      redirect_to sub_admins_index_admins_dashboard_index_path
    end
  end

  def enable_sub_admin
    if @sub_admin.status!="active"
      if @sub_admin.update(status: "active")
        redirect_to sub_admins_index_admins_dashboard_index_path
        flash[:notice] = "Sub Admin has been enabled successfully."
      else
        redirect_to sub_admins_index_admins_dashboard_index_path
        flash[:notice] = @sub_admin.errors.full_messages.to_sentence
      end
    else
      redirect_to sub_admins_index_admins_dashboard_index_path
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

  def find_sub_admin
    return flash[:notice] = "Id parameter is missing." unless params[:id].present?
    @sub_admin = Admin.find_by_id(params[:id])
    return flash[:notice] = "Sub Admin with this id is not present." unless @sub_admin.present?
  end

  def sub_admin_params
    params.permit(:f_name, :l_name, :email, :contact, :country_code, :location, :password, :image)
  end

end
