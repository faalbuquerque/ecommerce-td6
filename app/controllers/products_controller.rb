class ProductsController < ApplicationController
  before_action :find_product_stock, only: %i[show]

  def show
    @cart = Cart.new
    @shipping = Shipping.new
  end

  private

  def find_product_stock
    @product = Product.find(params[:id])
    @stock = Stock.to_product(sku: @product.sku)

    @quantities = @stock.map { |stock| stock[:quantity] }
    @quantity = @quantities.max
  end
end
