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
    @cart = Cart.new(carts_params)
    @cart.quantity = 1
    if params[:shipping_id].size.positive?
      @cart.save!
      redirect_to users_carts_path, notice: 'Produto adicionado ao carrrinho com sucesso!'
    else
      @stock = Stock.to_product(sku: @product.sku)
      flash[:message] = 'Obrigatório escolher o frete para adicionar ao carrinho'
      render 'products/show'
    end
  end

  private

  def carts_params
    params.permit(:address_id, :quantity, :product_id, :shipping_id).merge(user_id: current_user.id)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end
end
