class Users::CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  before_action :find_product, only: %i[create]
  before_action :find_shipping, only: %i[create]
  before_action :find_stock, only: %i[create]

  def index
    @carts = current_user.carts
  end

  def show
    @cart = Cart.find(params[:id])
  end

  def create
    @cart = current_user.carts.new(carts_params)
    if @cart.save
      flash.now[:notice] = t('.success')
      render 'users/carts/show'
    else
      flash.now[:notice] = t('.failure')
      render 'products/show'
    end
  end

  private

  def carts_params
    params.permit(:address_id, :product_id, :shipping_id)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_shipping
    @shipping = Shipping.chosen(params[:shipping_id])
  end

  def find_stock
    @stock = Stock.to_product(sku: @product.sku)
  end
end
