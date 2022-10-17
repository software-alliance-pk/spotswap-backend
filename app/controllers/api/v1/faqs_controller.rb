class Api::V1::FaqsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_faq, only: [:delete_faq, :update_faq]
  before_action :faq_params, only: [:create_faq, :update_faq]

  def index
    @faqs = Faq.all
  end
  
  def create_faq
    @faq = Faq.new(faq_params)
    if @faq.save
      @faq
    else
      render json: { error: render_error_messages(@faq)},status: :unprocessable_entity
    end
  end

  def update_faq
    if @faq.update(faq_params)
      @faq
    else
      render json: { error: render_error_messages(@faq)},status: :unprocessable_entity
    end
  end

  def delete_faq
      @faq.destroy
      render json: { message: "Faq is removed successfully"}, status: :ok
  end

  private

  def faq_params
    params.permit(:id, :question, :answer)
  end

  def find_faq
    render json: {error: "Faq id is missing"}, status: :precondition_failed unless params[:id].present?
    @faq = Faq.find_by(id: params[:id])
    render json: {error: "No such Faq is present"}, status: :unprocessable_entity unless @faq.present?
  end
end