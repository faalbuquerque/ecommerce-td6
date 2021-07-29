class Users::CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  before_action :check_shipping, only: %i[update]
  before_action :find_product, only: %i[create]
  before_action :find_shipping, only: %i[update]
  before_action :find_stock, only: %i[create]

  def index
    @carts = current_user.carts.where(status: 'pending')
  end

  def show
    @cart = Cart.find(params[:id])
  end

  def create
    @cart = Cart.new(carts_params)
    redirect_to users_carts_path, notice: t('.success') if @cart.save!
  end

  def update
    @cart = current_user.carts.find(params[:id])
    
    redirect_to users_cart_path(@cart), notice: t('.success') if @cart.update(create_params.merge(status: 'success'))

    #flash.now[:notice] = t('.failure')
    #render 'products/show'
  end

  def my_orders
    @carts = current_user.carts
  end

  def order
    @cart = Cart.find(params[:id])
    shipping = Shipping.find_status_by_order(@cart.service_order)
    if shipping.status
      @cart.update(status: shipping.status)
    else
      flash.now[:notice] = 'Atualização de status temporariamente indisponível'
    end
  end

  private

  def carts_params
    params.permit(:address_id, :product_id, :shipping_id).merge(user_id: current_user.id)
  end

  def create_params
    params.require(:cart).permit(:address_id, :product_id, :shipping_id).merge(shipping_params).merge(user_id: current_user.id)
  end

  def shipping_params
    shipping = JSON.parse(params[:cart][:shipping_id])
    {shipping_id: shipping['shipping_id'], shipping_name: shipping['name'], shipping_time: shipping['arrival_time'], shipping_price: shipping['price']}
  end

  def check_shipping
    raise ActiveRecord::RecordNotFound if params[:cart][:shipping_id].blank?
  rescue ActiveRecord::RecordNotFound
    redirect_to users_carts_path, alert: t('.required_shipping')
  end

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_shipping
    @shipping = Shipping.chosen(params[:cart][:shipping_id])
  end

  def find_stock
    @stock = Stock.to_product(sku: @product.sku)
  end
end
