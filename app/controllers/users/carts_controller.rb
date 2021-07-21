class Users::CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @carts = current_user.carts
  end

  def show
    @cart = Cart.find(params[:id])
    @shipping = Shipping.find(shipping_id: @cart.shipping_id)
  end

  def create
    @product = Product.find(params[:product_id])
    @cart = Cart.new
    set_params
    if @cart.save!
      flash[:notice] = 'Produto adicionado ao carrrinho com sucesso!'
      redirect_to users_cart_path(@cart), notice: 'Produto adicionado ao carrrinho com sucesso!'
    end
  end

  private

  def set_params
    if params[:address_id]
      @address = Address.find(params[:address_id])
      @cart.address = @address
    end
    @user = current_user
    @cart.user = @user
    @cart.quantity = 1
    @cart.product = @product
    @cart.shipping_id = params[:shipping_id]
  end
end
