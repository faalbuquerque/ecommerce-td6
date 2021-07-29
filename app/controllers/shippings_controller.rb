class ShippingsController < ApplicationController
  before_action :find_product, only: %i[index shippings_options]
  before_action :find_address, only: %i[shippings_options]

  def index
    session[:cep] = shipping_params[:cep]
    @shippings = Shipping.to_product(@product, shipping_params[:cep])
    render 'products/show'
  end

  def shippings_options
    @shippings = Shipping.to_product(@product, @address.cep)
    @carts = current_user.carts
    render 'users/carts/index'
  end

  private

  def shipping_params
    params.permit(:cep)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_address
    @address = current_user.addresses.find(params[:address_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_carts_path, alert: t('.required_address')
  end
end
