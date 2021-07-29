class Users::CartsController < User::UsersController
  before_action :find_product, only: %i[create]
  before_action :find_cart, only: %i[show order]
  before_action :find_apis, only: %i[create]
  before_action :setting_evaluation, only: %i[order]

  def index
    @carts = current_user.carts
  end

  def show; end

  def create
    @cart = current_user.carts.new(carts_params)
    if @cart.save
      flash.now[:notice] = t('.success')
      render 'users/carts/show'
    else
      flash.now[:notice] = t('.failure')
      render 'products/show'
    end
  end

  def my_orders
    @carts = current_user.carts
  end

  def order
    shipping = Shipping.find_status_by_order(@cart.service_order)
    if shipping.status
      @cart.update(status: shipping.status)
    else
      flash.now[:notice] = 'Atualização de status temporariamente indisponível'
    end
  end

  private

  def carts_params
    params.permit(:address_id, :product_id, :shipping_id)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_apis
    @stock = Stock.to_product(sku: @product.sku)
    @shipping = Shipping.chosen(params[:shipping_id])
  end

  def find_cart
    @cart = Cart.find(params[:id])
  end

  def setting_evaluation
    @user_evaluation = current_user.evaluations.where(product: @cart.product)
    @evaluation = Evaluation.new
  end
end
