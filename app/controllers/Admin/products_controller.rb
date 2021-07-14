class AProductsController < ApplicationController
  before_action :find_product , only: %i[show]
  def index; end

  def new
    @products = Product.all
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      @products = Product.all
      render :new
    end
  end

  def show; end

  private

  def product_params
    params.require(:product).permit(:name, :price, :brand, :description,
                                    :height, :length, :width, :weight,
                                    :product_picture, :fragile)
  end

  def find_product
    @product = Product.find(params[:id])
  end
end
