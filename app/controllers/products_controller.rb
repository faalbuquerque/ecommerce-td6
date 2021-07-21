class ProductsController < ApplicationController
  before_action :find_product, only: %i[show]

  def show
    @cart = Cart.new
    @stock = Stock.to_product(sku: @product.sku)
    @shipping = Shipping.new
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end
end
