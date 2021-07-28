class ProductsController < ApplicationController
  before_action :find_product, only: %i[show]

  def show
    @cart = Cart.new
    @stock = Stock.to_product(sku: @product.sku)

    # @stock = Stock.new(quantity: 1)
    # @shippings = [Shipping.new(id: 3, shipping_id: 3, name: 'Frete 1', distance: 30, price: 15, arrival_time: 10)]

    @shipping = Shipping.new
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end
end
