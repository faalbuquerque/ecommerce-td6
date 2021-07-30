class ShippingsController < ApplicationController
  before_action :find_product, only: %i[index shippings_options]
  before_action :find_address, only: %i[shippings_options]

  def index
    @shippings = Shipping.to_product(@product, Geocoder.search(params[:address_string]).first)
    render 'products/show'
  end

  def shippings_options
    @shippings = Shipping.to_product(@product, Geocoder.search(@geo).first)
    @carts = current_user.carts
    render 'users/carts/index'
  end

  private

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_address
    @address = current_user.addresses.find(params[:address_id])
    @geo = "#{@address.number} #{@address.street}, #{@address.neighborhood}, #{@address.city}, #{@address.state}"
  rescue ActiveRecord::RecordNotFound
    redirect_to users_carts_path, alert: t('.required_address')
  end
end
