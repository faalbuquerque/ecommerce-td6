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
    @cart = Cart.new(carts_params)
    redirect_to users_carts_path, notice: 'Produto adicionado ao carrrinho com sucesso!' if @cart.save!
  end

  private

  def carts_params
    params.permit(:address_id, :quantity, :product_id, :shipping_id).merge(user_id: current_user.id)
  end
end
