class Admins::GuidelinesController < ApplicationController
	before_action :authenticate_admin!
  before_action :find_faq, only: [:edit_faq, :destroy_faq, :update_faq]

	def terms_and_conditions
    @terms_and_conditions = Page.where(title: "Terms & Conditions")
    @notifications = Notification.where(is_clear: false).order(created_at: :desc)

	end

  def edit_terms_and_conditions
    @terms_and_conditions = Page.where(title: "Terms & Conditions")
    @notifications = Notification.where(is_clear: false).order(created_at: :desc)
	end

  def update_terms_and_conditions
    @page = Page.find_by(id: params[:term_id])
    if @page.content.update(body: params[:description])
      redirect_to terms_and_conditions_admins_guidelines_path
      flash[:notice] = "Terms and Conditions have been updated successfully."
    else
      redirect_to terms_and_conditions_admins_guidelines_path
      flash[:notice] = @page.content.errors.full_messages.to_sentence
    end
	end
  
  def privacy_policy
    @privacy_policy = Page.where(title: "Privacy Policy")
    @notifications = Notification.where(is_clear: false).order(created_at: :desc)
	end

  def edit_privacy_policy
    @privacy_policy = Page.where(title: "Privacy Policy")
    @notifications = Notification.where(is_clear: false).order(created_at: :desc)

	end

  def update_privacy_policy
    @page = Page.find_by(id: params[:policy_id])
    if @page.content.update(body: params[:description])
      redirect_to privacy_policy_admins_guidelines_path
      flash[:notice] = "Privacy Policy has been updated successfully."
    else
      redirect_to privacy_policy_admins_guidelines_path
      flash[:notice] = @page.content.errors.full_messages.to_sentence
    end
	end

  def faqs
    @faqs = Faq.all.order(created_at: :desc)
    @count = 0
    @notifications = Notification.where(is_clear: false).order(created_at: :desc)
	end

  def add_faq
    @notifications = Notification.where(is_clear: false).order(created_at: :desc)
	end

  def create_faq
    @faq = Faq.new(faq_params)
    if @faq.save
      redirect_to faqs_admins_guidelines_path
      flash[:notice] = "FAQ has been created successfully."
    else
      redirect_to faqs_admins_guidelines_path
      flash[:notice] = @faq.errors.full_messages.to_sentence
    end
	end

  def edit_faq
    @faq = Faq.find_by_id(params[:faq_id])
    @notifications = Notification.where(is_clear: false).order(created_at: :desc)
	end

  def update_faq
    if @faq.update(faq_params)
      redirect_to faqs_admins_guidelines_path
      flash[:notice] = "FAQ has been updated successfully."
    else
      redirect_to faqs_admins_guidelines_path
      flash[:notice] = @faq.errors.full_messages.to_sentence
    end
  end

  def destroy_faq
    @faq = Faq.find_by_id(params[:faq_id])
    if @faq.present?
      if @faq.destroy
        redirect_to faqs_admins_guidelines_path
        flash[:notice] = "FAQ has been destroyed successfully."
      else
        redirect_to faqs_admins_guidelines_path
        flash[:notice] = @faq.errors.full_messages.to_sentence
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

  def find_faq
    @faq = Faq.find_by_id(params[:faq_id])
    unless @faq.present?
      redirect_to faqs_admins_guidelines_path
      flash[:notice] = "FAQ with this Id is not present."
    end
  end

  def faq_params
    params.permit(:question, :answer)
  end
end
