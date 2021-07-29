class Users::EvaluationsController < ApplicationController
  before_action :find_product, only: %i[create]
  before_action :find_evaluation, only: %i[edit update]

  def create
    @evaluation = current_user.evaluations.new(evaluation_params)
    @evaluation.product = @product
    @evaluation.save!
    calc_rate
    redirect_to product_path(@product)
  end

  def edit; end

  def update
    @evaluation.update!(evaluation_params)
    redirect_to product_path(@evaluation.product)
  end

  private

  def evaluation_params
    params.require(:evaluation).permit(:rate, :comment)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_evaluation
    @evaluation = Evaluation.find(params[:id])
  end

  def calc_rate
    evaluated = Evaluation.where(product: @product)
    rate_count = 0
    sum = 0
    evaluated.each do |value|
      if value.rate.positive?
        rate_count += 1
        sum += value.rate
      end
    end
    @product.average_rating = sum / rate_count if rate_count.positive?
  end
end
