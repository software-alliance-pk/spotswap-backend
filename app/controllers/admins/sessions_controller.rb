# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController
  def destroy
    super
  end
end
