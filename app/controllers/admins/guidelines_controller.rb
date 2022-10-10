class Admins::GuidelinesController < ApplicationController
	before_action :authenticate_admin!

	def terms_and_conditions
	end

  def privacy_policy
	end

  def faqs
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
