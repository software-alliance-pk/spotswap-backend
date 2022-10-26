class Api::V1::FaqsController < Api::V1::ApiController
  before_action :check_the_params_of_request, only: [:create_faq,:update_faq]
  before_action :find_faq, only: [:delete_faq, :update_faq]
  before_action :faq_params, only: [:create_faq, :update_faq]

  def index
    @faqs = Faq.all.order(created_at: :desc)
  end
  
  def create_faq
    @faq = Faq.new(faq_params)
    if @faq.save
      @faq
    else
      render_error_messages(@faq)
    end
  end

  def update_faq
    if @faq.update(faq_params)
      @faq
    else
      render_error_messages(@faq)
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

  def check_the_params_of_request
    return render json: {error: "Id parameter is missing "}, status: :unprocessable_entity unless params[:id].present? || params[:action] == "create_faq"
    return render json: {error: "Question parameter is missing "}, status: :unprocessable_entity unless params[:question].present?
    return render json: {error: "Answer parameter is missing "}, status: :unprocessable_entity unless params[:answer].present?
  end

  def find_faq
    return render json: {error: "Id parameter is missing "}, status: :unprocessable_entity unless params[:id].present?
    @faq = Faq.find_by(id: params[:id])
    return render json: {error: "No such Faq is present"}, status: :unprocessable_entity unless @faq.present?
  end
end