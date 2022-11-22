class Admins::GuidelinesController < ApplicationController
	before_action :authenticate_admin!

	def terms_and_conditions
    @terms_and_conditions = Page.where(title: "Terms & Conditions")
	end

  def edit_terms_and_conditions
    @terms_and_conditions = Page.where(title: "Terms & Conditions")
	end

  def update_terms_and_conditions
    @page = Page.find_by(id: params[:id])
    if @page.content.update(body: params[:description])
      redirect_to terms_and_conditions_admins_guidelines_path
      flash[:alert] = "Terms and Conditions have been updated successfully."
    else
      redirect_to terms_and_conditions_admins_guidelines_path
      flash[:alert] = @page.content.errors.full_messages.to_sentence
    end
	end
  
  def privacy_policy
	end

  def faqs
    @faqs = Page.where(title: "FAQ")
    @count = 0
	end

  def edit_faq
	end

  def destroy_faq
    @faq = Page.find_by_id(params[:id])
    if @faq.present?
      if @faq.destroy
        redirect_to faqs_admins_guidelines_path
        flash[:alert] = "FAQ has been destroyed successfully."
      else
        redirect_to faqs_admins_guidelines_path
        flash[:alert] = @faq.errors.full_messages.to_sentence
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
