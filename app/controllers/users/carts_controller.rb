class Users::CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  before_action :check_shipping, only: %i[update]

  def index
    @carts = current_user.carts.where(status: 'pending')
  end

  def show
    @cart = Cart.find(params[:id])
    @shipping = Shipping.find(shipping_id: @cart.shipping_id)
  end

  def create
    @cart = Cart.new(carts_params)
    @cart.product_id = params[:product_id]
    redirect_to users_carts_path, notice: t('.success') if @cart.save!
  end

  def update
    @cart = current_user.carts.find(params[:id])

    redirect_to users_cart_path(@cart), notice: t('.success') if @cart.update!(carts_params.merge(status: 'success'))
  end

  private

  def carts_params
    params.require(:cart).permit(:address_id, :product_id, :shipping_id).merge(user_id: current_user.id)
  end

  def check_shipping
    raise ActiveRecord::RecordNotFound if params[:cart][:shipping_id].blank?
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Selecione o frete'
    redirect_to users_carts_path
  end
end
