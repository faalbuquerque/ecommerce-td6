class ProductsController < ApplicationController
  def index ; end

  def new 
    @product = Product.new
  end

  def create
    params[:fragile] = !(params[:fragile] == '0')
    @product = Product.new(product_params)
    if @product.save
      byebug
      redirect_to @product
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :brand, :description, :height, :length, :width, :weight, :product_picture, :fragile)
  end
end
