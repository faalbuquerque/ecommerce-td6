class Users::CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  before_action :find_product, only: %i[create]

  def index
    @carts = current_user.carts
  end

  def show
    @cart = Cart.find(params[:id])
    @shipping = Shipping.find(shipping_id: @cart.shipping_id)
  end

  def create
    @cart = current_user.carts.new(carts_params)
    if @cart.save
      redirect_to users_carts_path, notice: t('.success')
    else
      @stock = Stock.to_product(sku: @product.sku)
      flash.now[:notice] = t('.failure')
      render 'products/show'
    end
  end

  def my_orders
    @carts = current_user.carts
    @carts = Cart.all
  end

  def order
    @cart = Cart.find(params[:id])
    shipping = Shipping.find_status(@cart.service_order)
    find_status(shipping)
    @carts = Cart.all
  end

  private

  def carts_params
    params.permit(:address_id, :product_id, :shipping_id)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_status(shipping)
    status_hash = { 'Pedido Realizado': 0, 'Pedido Entregue': 1 }
    status = status_hash[:"#{shipping.status}"]
    if status
      @cart.update(status: status)
    else
      flash.now[:notice] = 'Atualização de status temporariamente indisponível'
    end
  end
end
