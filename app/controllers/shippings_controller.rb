class ShippingsController < ApplicationController
  before_action :find_product, only: %i[index]

  def index
    find_params
    find_adresses
    @shippings = Shipping.to_product(params.permit(:cep, :product_id,
                                                   :sku, :weight, :length, :width))
    render 'products/show'
  end

  private

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_params
    sku = @product.sku
    weight = @product.weight
    length = @product.length
    width = @product.width
    params[:sku] = sku
    params[:weight] = weight
    params[:length] = length
    params[:width] = width
  end

  def find_adresses
    @addresses = current_user.addresses if current_user
  end
end
