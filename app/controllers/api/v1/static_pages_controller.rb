class Api::V1::StaticPagesController < Api::V1::ApiController
  before_action :find_page, only: [:index]

  def index
    @page
  end

  def find_page
    return render json: {message: "Permalink parameter is missing"},status: ok unless params[:permalink].present?
    @page = Page.find_by(permalink: params[:permalink])
    return render json: { message: "Page does not exist in the database" }, status: :not_found unless @page.present?
  end
end