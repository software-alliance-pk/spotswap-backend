class Api::V1::StaticPagesController < Api::V1::ApiController

    def index
      render json: {message: "Permalink parameter is missing"},status: ok unless params[:permalink].present?
      @page = Page.find_by(permalink: params[:permalink])
      if @page
        @page
      else
        render json: { message: "Page does not exist in the database" }, status: :not_found
      end
    end
  end