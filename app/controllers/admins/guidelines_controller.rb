class Admins::GuidelinesController < ApplicationController
	before_action :authenticate_admin!

	def terms_and_conditions
    @terms_and_conditions = Page.where(title: "Terms & Conditions")
	end

  def edit_terms_and_conditions
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
	end

  def edit_faqs
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
