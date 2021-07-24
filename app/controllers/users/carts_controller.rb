class Users::CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @carts = current_user.carts.where(status: 'pending')
  end

  def show
    @cart = Cart.find(params[:id])
    @shipping = Shipping.find(shipping_id: @cart.shipping_id)
  end

  def create
    #address = Address.find(params[:cart][:address_id])
    product = Product.find(params[:product_id])
   # @shippings = Shipping.to_product(product, address.cep)
    @cart = Cart.new(carts_params)
    #@cart.address = address
    #@cart.shipping_id = @shippings.first.id
    redirect_to users_carts_path, notice: 'Produto adicionado ao carrrinho com sucesso!' if @cart.save!
  end

  def update
    raise StandardError if params[:cart][:address_id].blank?

    @cart = current_user.carts.find(params[:id])
    if @cart.update!(address_id: params[:cart][:address_id], status: 'success')
      redirect_to users_cart_path(@cart), notice: 'Pedido realizado com sucesso!'
  end 
  rescue
    flash[:alert] = 'Endereço obrigatório'
    redirect_to users_carts_path
  end

  private

  def carts_params
    params.permit(:address_id, :quantity, :product_id, :shipping_id).merge(user_id: current_user.id)
  end
end
