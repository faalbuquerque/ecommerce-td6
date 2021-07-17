class Admin::ProductsController < ApplicationController
  before_action :find_product, only: %i[show edit update]
  before_action :all_products, only: %i[index new create edit update]

  def index; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_product_path(@product)
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: 'Opção atualizada com sucesso'
    else
      render :edit
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :brand, :description,
                                    :height, :length, :width, :weight,
                                    :product_picture, :fragile, :sku)
  end

  def find_product
    @product = Product.find(params[:id])
  end

  def all_products
    @products = Product.all
  end
end
