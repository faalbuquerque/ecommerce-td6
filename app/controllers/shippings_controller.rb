class ShippingsController < ApplicationController
  before_action :find_product, only: %i[index]

  def index
    find_params
    find_adresses
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

  def find_params
    params[:sku] = @product.sku
    params[:weight] = @product.weight
    params[:length] = @product.length
    params[:width] = @product.width
  end

  def find_adresses
    @addresses = current_user.addresses if current_user
  end
end
