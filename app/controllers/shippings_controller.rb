class ShippingsController < ApplicationController
  before_action :find_product, only: %i[index]
  before_action :find_address, only: %i[index]

  def index
    session[:cep] = shipping_params[:cep]
    @shippings = Shipping.to_product(@product, shipping_params[:cep])
    render 'products/show'
  end

  private

  def shipping_params
    params.permit(:cep)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_address
    #@addresses = current_user.addresses if current_user
  end
end
