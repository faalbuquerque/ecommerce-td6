class ProductsController < ApplicationController
  before_action :find_product, only: %i[show]

  def show; end

  private

  def find_product
    @product = Product.find(params[:id])
  end
end
